# Some of these variables will need to be actually defined with ENV Variables
# See: https://github.com/robotframework/robotframework/blob/master/doc/userguide/src/CreatingTestData/Variables.rst#environment-variables

HOST =                           "http://localhost:4000/api"
ADMIN_HOST =                     "http://localhost:4000/admin/api"
CONTENT_TYPE_HEADER =            "application/vnd.omisego.v1+json"
FORM_DATA_CONTENT_TYPE_HEADER =  "application/x-www-form-urlencoded"
ACCEPT_HEADER =                  "application/vnd.omisego.v1+json"
ADMIN_EMAIL =                    "admin@example.com"
ADMIN_PASSWORD =                 "password"
ADMIN_1_EMAIL =                  "admin1@example.com"

ADMIN_AUTH_SCHEMA =              "OMGAdmin"
SERVER_AUTH_SCHEMA =             "OMGServer"
CLIENT_AUTH_SCHEMA =             "OMGClient"

SERVER_AUTH =                    "OMGServer VS1DZGE4bWRJdE14SmVhUGw3Yk1rcFBXcURfZlVvTmtvSWNYUnQyRWhNWTpsOEJtb2FWaE1menM2Y2ZOY3hjYmZyUzRmY3picFJySy1yeGxuWS1ONmRR"

# Endpoints:

## Admin
#### Session
ADMIN_LOGIN =                    "login"
ADMIN_LOGOUT =                   "logout"
ADMIN_SWITCH_ACCOUNT =           "auth_token.switch_account"
ADMIN_RESET_PASSWORD =           "password.reset"

#### Token
ADMIN_TOKEN_CREATE =             "token.create"
ADMIN_TOKEN_MINT =               "token.mint"
ADMIN_TOKEN_GET =                "token.get"
ADMIN_TOKEN_LIST =               "token.all"


#### Account
ADMIN_ACCOUNT_CREATE =           "account.create"
ADMIN_ACCOUNT_UPDATE =           "account.update"
ADMIN_ACCOUNT_UPLOAD_AVATAR =    "account.upload_avatar"
ADMIN_ACCOUNT_ASSIGN_USER =      "account.assign_user"
ADMIN_ACCOUNT_LIST_USERS =       "account.list_users"
ADMIN_ACCOUNT_UNASSIGN_USER =    "account.unassign_user"
ADMIN_ACCOUNT_GET =              "account.get"
ADMIN_ACCOUNT_ALL =              "account.all"
ADMIN_ACCOUNT_GET_WALLETS =      "account.get_wallets"

#### Admin
ADMIN_ADMIN_ALL =                "admin.all"
ADMIN_ADMIN_GET =                "admin.get"

#### Category
ADMIN_CATEGORY_CREATE =         "category.create"
ADMIN_CATEGORY_UPDATE =         "category.update"
ADMIN_CATEGORY_GET =            "category.get"
ADMIN_CATEGORY_ALL =            "category.all"
ADMIN_CATEGORY_DELETE =         "category.delete"

#### Transaction
ADMIN_TRANSACTION_CREATE =      "transaction.create"
ADMIN_TRANSACTION_GET =         "transaction.get"
ADMIN_TRANSACTION_ALL =         "transaction.all"

#### Users

ADMIN_USER_ALL =                "user.all"
ADMIN_USER_GET =                "user.get"
ADMIN_USER_ME_GET =             "me.get"
ADMIN_USER_ME_UPDATE =          "me.update"
ADMIN_USER_ME_GET_ACCOUNT =     "me.get_account"
ADMIN_USER_ME_GET_ACCOUNTS =    "me.get_accounts"
ADMIN_USER_GET_WALLETS =        "user.get_wallets"

#### API keys

ADMIN_KEY_ACCESS_ALL =          "access_key.all"
ADMIN_KEY_ACCESS_CREATE =       "access_key.create"
ADMIN_KEY_ACCESS_DELETE =       "access_key.delete"
ADMIN_KEY_API_ALL =             "api_key.all"
ADMIN_KEY_API_CREATE =          "api_key.create"
ADMIN_KEY_API_DELETE =          "api_key.delete"


## Ewallet
USER_CREATE =                    "user.create"
USER_GET =                       "user.get"
USER_UPDATE =                    "user.update"

LOGIN =                          "login"

USER_LIST_WALLETS =              "user.list_wallets"
