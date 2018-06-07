# This library is a simplified and slightly modified version of https://github.com/bulkan/robotframework-requests
# All credits goes to the original author
#
# Copyright (c) 2016 Bulkan Evcimen
#
#
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
#
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
#
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

import json
import sys

import requests
import logging
from requests.packages.urllib3.util import Retry
import robot
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn

from RequestsLibrary.compat import httplib, urlencode, PY3

try:
    from requests_ntlm import HttpNtlmAuth
except ImportError:
    pass


class WritableObject:
    ''' HTTP stream handler '''

    def __init__(self):
        self.content = []

    def write(self, string):
        self.content.append(string)


class SimplePost(object):
    ROBOT_LIBRARY_SCOPE = 'Global'

    def __init__(self):
        self._cache = robot.utils.ConnectionCache('No sessions created')
        self.builtin = BuiltIn()
        self.debug = 0

    def _create_session(
            self,
            alias,
            url,
            headers,
            cookies,
            auth,
            timeout,
            max_retries,
            backoff_factor,
            proxies,
            verify,
            debug,
            disable_warnings):
        """ Create Session: create a HTTP session to a server

        ``url`` Base url of the server

        ``alias`` Robot Framework alias to identify the session

        ``headers`` Dictionary of default headers

        ``auth`` List of username & password for HTTP Basic Auth

        ``timeout`` Connection timeout

        ``max_retries`` The maximum number of retries each connection should attempt.

        ``backoff_factor`` The pause between for each retry

        ``proxies`` Dictionary that contains proxy urls for HTTP and HTTPS communication

        ``verify`` Whether the SSL cert will be verified. A CA_BUNDLE path can also be provided.

        ``debug`` Enable http verbosity option more information
                https://docs.python.org/2/library/httplib.html#httplib.HTTPConnection.set_debuglevel

        ``disable_warnings`` Disable requests warning useful when you have large number of testcases
        """

        self.builtin.log('Creating session: %s' % alias, 'DEBUG')
        s = session = requests.Session()
        s.headers.update(headers)
        s.auth = auth if auth else s.auth
        s.proxies = proxies if proxies else s.proxies

        try:
            max_retries = int(max_retries)
        except ValueError as err:
            raise ValueError("Error converting max_retries parameter: %s"   % err)

        if max_retries > 0:
            http = requests.adapters.HTTPAdapter(max_retries=Retry(total=max_retries, backoff_factor=backoff_factor))
            https = requests.adapters.HTTPAdapter(max_retries=Retry(total=max_retries, backoff_factor=backoff_factor))

            # Replace the session's original adapters
            s.mount('http://', http)
            s.mount('https://', https)

        # Disable requests warnings, useful when you have large number of testcase
        # you will observe drastical changes in Robot log.html and output.xml files size
        if disable_warnings:
            logging.basicConfig() # you need to initialize logging, otherwise you will not see anything from requests
            logging.getLogger().setLevel(logging.ERROR)
            requests_log = logging.getLogger("requests")
            requests_log.setLevel(logging.ERROR)
            requests_log.propagate = True
            if not verify:
                requests.packages.urllib3.disable_warnings()

        # verify can be a Boolean or a String
        if isinstance(verify, bool):
            s.verify = verify
        elif isinstance(verify, str) or isinstance(verify, unicode):
            if verify.lower() == 'true' or verify.lower() == 'false':
                s.verify = self.builtin.convert_to_boolean(verify)
            else:
                # String for CA_BUNDLE, not a Boolean String
                s.verify = verify
        else:
            # not a Boolean nor a String
            s.verify = verify

        # cant pass these into the Session anymore
        self.timeout = float(timeout) if timeout is not None else None
        self.cookies = cookies
        self.verify = verify if self.builtin.convert_to_boolean(verify) != True else None

        s.url = url

        # Enable http verbosity
        if int(debug) >= 1:
            self.debug = int(debug)
            httplib.HTTPConnection.debuglevel = self.debug

        self._cache.register(session, alias=alias)
        return session

    def create_session(self, alias, url, headers={}, cookies=None,
                       auth=None, timeout=None, proxies=None,
                       verify=False, debug=0, max_retries=3, backoff_factor=0.10, disable_warnings=0):
        """ Create Session: create a HTTP session to a server

        ``url`` Base url of the server

        ``alias`` Robot Framework alias to identify the session

        ``headers`` Dictionary of default headers

        ``auth`` List of username & password for HTTP Basic Auth

        ``timeout`` Connection timeout

        ``proxies`` Dictionary that contains proxy urls for HTTP and HTTPS communication

        ``verify`` Whether the SSL cert will be verified. A CA_BUNDLE path can also be provided.
                 Defaults to False.

        ``debug`` Enable http verbosity option more information
                https://docs.python.org/2/library/httplib.html#httplib.HTTPConnection.set_debuglevel

        ``max_retries`` The maximum number of retries each connection should attempt.

        ``backoff_factor`` The pause between for each retry

        ``disable_warnings`` Disable requests warning useful when you have large number of testcases
        """
        auth = requests.auth.HTTPBasicAuth(*auth) if auth else None

        logger.info('Creating Session using : alias=%s, url=%s, headers=%s, \
                    cookies=%s, auth=%s, timeout=%s, proxies=%s, verify=%s, \
                    debug=%s ' % (alias, url, headers, cookies, auth, timeout,
                                  proxies, verify, debug))

        return self._create_session(
            alias,
            url,
            headers,
            cookies,
            auth,
            timeout,
            max_retries,
            backoff_factor,
            proxies,
            verify,
            debug,
            disable_warnings)

    def delete_all_sessions(self):
        """ Removes all the session objects """
        logger.info('Delete All Sessions')

        self._cache.empty_cache()

    def post_request(
            self,
            alias,
            uri,
            data=None,
            json=None,
            params=None,
            headers=None,
            files=None,
            allow_redirects=None,
            timeout=None):
        """ Send a POST request on the session object found using the
        given `alias`

        ``alias`` that will be used to identify the Session object in the cache

        ``uri`` to send the POST request to

        ``data`` a dictionary of key-value pairs that will be urlencoded
               and sent as POST data
               or binary data that is sent as the raw body content
               or passed as such for multipart form data if ``files`` is also
                  defined

        ``json`` a value that will be json encoded
               and sent as POST data if files or data is not specified

        ``params`` url parameters to append to the uri

        ``headers`` a dictionary of headers to use with the request

        ``files`` a dictionary of file names containing file data to POST to the server

        ``allow_redirects`` Boolean. Set to True if POST/PUT/DELETE redirect following is allowed.

        ``timeout`` connection timeout
        """
        session = self._cache.switch(alias)
        if not files:
            data = self._format_data_according_to_header(session, data, headers)
        redir = True if allow_redirects is None else allow_redirects

        response = self._body_request(
            "post",
            session,
            uri,
            data,
            json,
            params,
            files,
            headers,
            redir,
            timeout)
        dataStr = self._format_data_to_log_string_according_to_header(data, headers)
        logger.info('Post Request using : alias=%s, uri=%s, data=%s, json=%s, headers=%s, files=%s, allow_redirects=%s '
                    % (alias, uri, dataStr, json, headers, files, redir))

        return response

    def _body_request(
            self,
            method_name,
            session,
            uri,
            data,
            json,
            params,
            files,
            headers,
            allow_redirects,
            timeout):
        self._capture_output()

        method = getattr(session, method_name)
        resp = method(self._get_url(session, uri),
                      data=data,
                      json=json,
                      params=self._utf8_urlencode(params),
                      files=files,
                      headers=headers,
                      allow_redirects=allow_redirects,
                      timeout=self._get_timeout(timeout),
                      cookies=self.cookies,
                      verify=self.verify)

        self._print_debug()

        # Store the last session object
        session.last_resp = resp

        self.builtin.log(method_name + ' response: ' + resp.text, 'DEBUG')

        return resp

    def _get_url(self, session, uri):
        """
        Helper method to get the full url
        """
        url = session.url
        if uri:
            slash = '' if uri.startswith('/') else '/'
            url = "%s%s%s" % (session.url, slash, uri)
        return url

    def _get_timeout(self, timeout):
        return float(timeout) if timeout is not None else self.timeout

    def _capture_output(self):
        if self.debug >= 1:
            self.http_log = WritableObject()
            sys.stdout = self.http_log

    def _print_debug(self):
        if self.debug >= 1:
            sys.stdout = sys.__stdout__  # Restore stdout
            if PY3:
                debug_info = ''.join(
                    self.http_log.content).replace(
                    '\\r',
                    '').replace(
                    '\'',
                    '')
            else:
                debug_info = ''.join(
                    self.http_log.content).replace(
                    '\\r',
                    '').decode('string_escape').replace(
                    '\'',
                    '')

            # Remove empty lines
            debug_info = "\n".join(
                [ll.rstrip() for ll in debug_info.splitlines() if ll.strip()])
            self.builtin.log(debug_info, 'DEBUG')

    def _utf8_urlencode(self, data):

        if self._is_string_type(data):
            return data.encode('utf-8')

        if not isinstance(data, dict):
            return data

        utf8_data = {}
        for k, v in data.items():
            if self._is_string_type(v):
                v = v.encode('utf-8')
            utf8_data[k] = v
        return urlencode(utf8_data)

    def _format_data_according_to_header(self, session, data, headers):
        headers = self._merge_headers(session, headers)

        if data is not None and headers is not None and 'Content-Type' in headers and not self._is_json(data):
            if headers['Content-Type'].find("application/json") != -1:
                data = json.dumps(data)
            elif headers['Content-Type'].find("application/x-www-form-urlencoded") != -1:
                data = self._utf8_urlencode(data)
        else:
            data = self._utf8_urlencode(data)

        return data

    def _format_data_to_log_string_according_to_header(self, data, headers):
        dataStr = "<empty>"
        if data is not None and headers is not None and 'Content-Type' in headers:
            if (headers['Content-Type'].find("application/json") != -1) or \
                    (headers['Content-Type'].find("application/x-www-form-urlencoded") != -1):
                if isinstance(data, bytes):
                    dataStr = data.decode('utf-8')
                else:
                    dataStr = data
            else:
                dataStr = "<" + headers['Content-Type'] + ">"

        return dataStr

    @staticmethod
    def _merge_headers(session, headers):
        if headers is None:
            headers = {}
        else:
            headers = headers.copy()

        headers.update(session.headers)

        return headers

    @staticmethod
    def _is_string_type(data):
        if PY3 and isinstance(data, str):
            return True
        elif not PY3 and isinstance(data, unicode):
            return True
        return False
