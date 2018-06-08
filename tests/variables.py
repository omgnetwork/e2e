# Some of these variables will need to be actually defined with ENV Variables
# See: https://github.com/robotframework/robotframework/blob/master/doc/userguide/src/CreatingTestData/Variables.rst#environment-variables

HOST =                 "http://localhost:4000/api"
ADMIN_HOST =           "http://localhost:4000/admin/api"
CONTENT_TYPE_HEADER =  "application/vnd.omisego.v1+json"
ACCEPT_HEADER =        "application/vnd.omisego.v1+json"
ADMIN_EMAIL =          "admin@example.com"
ADMIN_PASSWORD =       "password"

ADMIN_AUTH_SCHEMA =    "OMGAdmin"

SERVER_AUTH =          "OMGServer TTF5TnRUMDZ0U3JlZU1FOEhiYXRKVDVsaVp4UUZObmIwQjJhY180VmVWODpOQkg4WDRNSW9GaVhYT2tHRGlLeFQ3MHlXRmF0cUlzU2hGSjgtVWZZRXdr"


# Endpoints:

## Admin

ADMIN_LOGIN =          "login"

## Ewallet
USER_CREATE =          "user.create"
USER_GET =             "user.get"
USER_UPDATE =          "user.update"

LOGIN =                "login"

USER_LIST_WALLETS =    "user.list_wallets"
