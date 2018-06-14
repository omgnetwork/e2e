# Some of these variables will need to be actually defined with ENV Variables
# See: https://github.com/robotframework/robotframework/blob/master/doc/userguide/src/CreatingTestData/Variables.rst#environment-variables
import os

HOST =                                   "http://localhost:4000/api"
ADMIN_HOST =                             "http://localhost:4000/admin/api"
CONTENT_TYPE_HEADER =                    "application/vnd.omisego.v1+json"
FORM_DATA_CONTENT_TYPE_HEADER =          "application/x-www-form-urlencoded"
ACCEPT_HEADER =                          "application/vnd.omisego.v1+json"
ADMIN_EMAIL =                            os.getenv("E2E_TEST_ADMIN_EMAIL", "test_admin@example.com")
ADMIN_PASSWORD =                         os.getenv("E2E_TEST_ADMIN_PASSWORD", "password")
ADMIN_1_EMAIL =                          os.getenv("E2E_TEST_ADMIN_1_EMAIL", "test_admin_1@example.com")
ADMIN_1_PASSWORD =                       os.getenv("E2E_TEST_ADMIN_1_PASSWORD", "password")

ADMIN_AUTH_SCHEMA =                      "OMGAdmin"
SERVER_AUTH_SCHEMA =                     "OMGServer"
CLIENT_AUTH_SCHEMA =                     "OMGClient"

# Endpoints:

## Admin
#### Session
ADMIN_LOGIN =                           "admin.login" #OK
ADMIN_LOGOUT =                          "admin.logout" #OK
ADMIN_SWITCH_ACCOUNT =                  "auth_token.switch_account" #OK
ADMIN_RESET_PASSWORD =                  "admin.reset_password" #OK

#### Admin
ADMIN_ADMIN_ALL =                       "admin.all" #OK
ADMIN_ADMIN_GET =                       "admin.get" #OK
ADMIN_ADMIN_ME_GET =                    "me.get" #OK
ADMIN_ADMIN_ME_UPDATE =                 "me.update" #OK
ADMIN_ADMIN_ME_GET_ACCOUNT =            "me.get_account" #OK
ADMIN_ADMIN_ME_GET_ACCOUNTS =           "me.get_accounts" #OK

#### User Session
ADMIN_USER_LOGIN =                      "user.login"
ADMIN_USER_LOGOUT =                     "user.logout"

#### Users
ADMIN_USER_ALL =                        "user.all" #OK
ADMIN_USER_CREATE =                     "user.create" #OK
ADMIN_USER_UPDATE =                     "user.update" #OK
ADMIN_USER_GET =                        "user.get" #OK
ADMIN_USER_GET_WALLETS =                "user.get_wallets" #OK

#### Token
ADMIN_TOKEN_LIST =                      "token.all" #OK
ADMIN_TOKEN_GET =                       "token.get" #OK
ADMIN_TOKEN_CREATE =                    "token.create" #OK
ADMIN_TOKEN_STATS =                     "token.stats" #OK
ADMIN_TOKEN_GET_MINTS =                 "token.get_mints" #OK
ADMIN_TOKEN_MINT =                      "token.mint" #OK

#### Category
ADMIN_CATEGORY_ALL =                    "category.all" #OK
ADMIN_CATEGORY_GET =                    "category.get" #OK
ADMIN_CATEGORY_CREATE =                 "category.create" #OK
ADMIN_CATEGORY_UPDATE =                 "category.update" #OK
ADMIN_CATEGORY_DELETE =                 "category.delete" #OK

#### Account
ADMIN_ACCOUNT_ALL =                     "account.all" #OK
ADMIN_ACCOUNT_GET =                     "account.get" #OK
ADMIN_ACCOUNT_CREATE =                  "account.create" #OK
ADMIN_ACCOUNT_UPDATE =                  "account.update" #OK
ADMIN_ACCOUNT_UPLOAD_AVATAR =           "account.upload_avatar"
ADMIN_ACCOUNT_GET_USERS =               "account.get_users" #OK
ADMIN_ACCOUNT_ASSIGN_USER =             "account.assign_user" #OK
ADMIN_ACCOUNT_UNASSIGN_USER =           "account.unassign_user" #OK
ADMIN_ACCOUNT_GET_WALLETS =             "account.get_wallets" #OK

#### Wallets
ADMIN_WALLET_ALL =                      "wallet.all" #OK
ADMIN_WALLET_CREATE =                   "wallet.create" #OK
ADMIN_WALLET_GET =                      "wallet.get" #OK

#### Transaction
ADMIN_USER_GET_TRANSACTIONS =           "user.get_transactions" #OK
ADMIN_USER_CREDIT_WALLET =              "user.credit_wallet" #OK
ADMIN_USER_DEBIT_WALLET =               "user.debit_wallet" #OK
ADMIN_TRANSACTION_ALL =                 "transaction.all" #OK
ADMIN_TRANSACTION_GET =                 "transaction.get" #OK
ADMIN_TRANSACTION_CREATE =              "transaction.create" #OK

#### Transaction Request
ADMIN_TRANSACTION_REQUEST_CREATE =      "transaction_request.create"
ADMIN_TRANSACTION_REQUEST_GET =         "transaction_request.get"
ADMIN_TRANSACTION_REQEUST_CONSUME =     "transaction_request.consume"

#### Transaction Consumption
ADMIN_TRANSACTION_CONSUMPTION_APPROVE = "transaction_consumption_appove"
ADMIN_TRANSACTION_CONSUMPTION_REJECT =  "transaction_consumption.reject"

#### API keys
ADMIN_KEY_ACCESS_ALL =                  "access_key.all" #OK
ADMIN_KEY_ACCESS_CREATE =               "access_key.create" #OK
ADMIN_KEY_ACCESS_DELETE =               "access_key.delete" #OK
ADMIN_KEY_API_ALL =                     "api_key.all" #OK
ADMIN_KEY_API_CREATE =                  "api_key.create" #OK
ADMIN_KEY_API_DELETE =                  "api_key.delete" #OK

#### Settings

ADMIN_GET_SETTINGS =                    "settings.all" #OK
