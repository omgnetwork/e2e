This repository contains acceptance tests for the [eWallet SDK](https://github.com/omisego/ewallet) written using [Robot Framework](http://robotframework.org/)

# Setup

The tests rely on test data inserted in a clean instance of the eWallet SDK. These data can be seeded following [these instructions](https://github.com/omisego/ewallet/blob/master/docs/tests/e2e.md).

Required libraries should be installed using pip, you can find more information on how to setup Robot Framework [here](https://github.com/robotframework/robotframework/blob/master/INSTALL.rst).

This are the libraries that you need to install:

- `pip install -U requests`
- `pip install -U robotframework-requests`
- `pip install -U robotframework`
- `pip install -U robotframework-websocketclient`

# Variables

## Environment variables

There are 6 environment variables that need to be created in order to run the tests:

- `E2E_HTTP_HOST`: The base HTTP URL of the eWallet SDK (ie: http://example.com)
- `E2E_SOCKET_HOST`: The base socket URL of the eWallet SDK (ie: ws://example.com)

The following variables define the email/password of the 2 needed admins. They can be defined before seeding the test data in the eWallet using [these environment variables](https://github.com/omisego/ewallet/blob/master/docs/setup/env.md#e2e-tests)

- `E2E_TEST_ADMIN_EMAIL`
- `E2E_TEST_ADMIN_PASSWORD`
- `E2E_TEST_ADMIN_1_EMAIL`
- `E2E_TEST_ADMIN_1_PASSWORD`
