# Some of these variables will need to be actually defined with ENV Variables
# See: https://github.com/robotframework/robotframework/blob/master/doc/userguide/src/CreatingTestData/Variables.rst#environment-variables
import os

HTTP_BASE_HOST =                              os.getenv("E2E_HTTP_HOST", "http://localhost:4000")
SOCKET_BASE_HOST =                            os.getenv("E2E_SOCKET_HOST", "ws://localhost:4000")
CLIENT_HOST =                                 HTTP_BASE_HOST + "/api/client"
ADMIN_HOST =                                  HTTP_BASE_HOST + "/api/admin"
CLIENT_SOCKET_HOST =                          SOCKET_BASE_HOST + "/api/client/socket"
ADMIN_SOCKET_HOST =                           SOCKET_BASE_HOST + "/api/admin/socket"
RESET_PASSWORD_URL =                          HTTP_BASE_HOST + "/admin/update_password?email={email}&token={token}"
CONTENT_TYPE_HEADER =                         "application/vnd.omisego.v1+json"
FORM_DATA_CONTENT_TYPE_HEADER =               "application/x-www-form-urlencoded"
ACCEPT_HEADER =                               "application/vnd.omisego.v1+json"
ADMIN_EMAIL =                                 os.getenv("E2E_TEST_ADMIN_EMAIL", "test_admin@example.com")
ADMIN_PASSWORD =                              os.getenv("E2E_TEST_ADMIN_PASSWORD", "password")
ADMIN_1_EMAIL =                               os.getenv("E2E_TEST_ADMIN_1_EMAIL", "test_admin_1@example.com")
ADMIN_1_PASSWORD =                            os.getenv("E2E_TEST_ADMIN_1_PASSWORD", "password")

ADMIN_AUTH_SCHEMA =                           "OMGAdmin"
PROVIDER_AUTH_SCHEMA =                        "OMGProvider"
CLIENT_AUTH_SCHEMA =                          "OMGClient"

# Endpoints:

## Admin
### Session
ADMIN_LOGIN =                                "admin.login" #OK
ADMIN_LOGOUT =                               "me.logout" #OK
ADMIN_SWITCH_ACCOUNT =                       "auth_token.switch_account" #OK
ADMIN_RESET_PASSWORD =                       "admin.reset_password" #OK

### Admin
ADMIN_ADMIN_ALL =                            "admin.all" #OK
ADMIN_ADMIN_GET =                            "admin.get" #OK
ADMIN_ADMIN_ME_GET =                         "me.get" #OK
ADMIN_ADMIN_ME_UPDATE =                      "me.update" #OK
ADMIN_ADMIN_ME_UPDLOAD_AVATAR =              "me.upload_avatar" #OK
ADMIN_ADMIN_ME_GET_ACCOUNT =                 "me.get_account" #OK
ADMIN_ADMIN_ME_GET_ACCOUNTS =                "me.get_accounts" #OK

### User Session
ADMIN_USER_LOGIN =                           "user.login" #OK
ADMIN_USER_LOGOUT =                          "user.logout" #OK

### Users
ADMIN_USER_ALL =                             "user.all" #OK
ADMIN_USER_CREATE =                          "user.create" #OK
ADMIN_USER_UPDATE =                          "user.update" #OK
ADMIN_USER_GET =                             "user.get" #OK
ADMIN_USER_GET_WALLETS =                     "user.get_wallets" #OK
ADMIN_USER_GET_CONSUMPTIONS =                "user.get_transaction_consumptions" #OK
ADMIN_USER_GET_TRANSACTIONS =                "user.get_transactions" #OK

### Token
ADMIN_TOKEN_LIST =                           "token.all" #OK
ADMIN_TOKEN_GET =                            "token.get" #OK
ADMIN_TOKEN_CREATE =                         "token.create" #OK
ADMIN_TOKEN_UPDATE =                         "token.update" #OK
ADMIN_TOKEN_STATS =                          "token.stats" #OK
ADMIN_TOKEN_GET_MINTS =                      "token.get_mints" #OK
ADMIN_TOKEN_MINT =                           "token.mint" #OK

### Category
ADMIN_CATEGORY_ALL =                         "category.all" #OK
ADMIN_CATEGORY_GET =                         "category.get" #OK
ADMIN_CATEGORY_CREATE =                      "category.create" #OK
ADMIN_CATEGORY_UPDATE =                      "category.update" #OK
ADMIN_CATEGORY_DELETE =                      "category.delete" #OK

### Account
ADMIN_ACCOUNT_ALL =                          "account.all" #OK
ADMIN_ACCOUNT_GET =                          "account.get" #OK
ADMIN_ACCOUNT_CREATE =                       "account.create" #OK
ADMIN_ACCOUNT_UPDATE =                       "account.update" #OK
ADMIN_ACCOUNT_UPLOAD_AVATAR =                "account.upload_avatar" #OK
ADMIN_ACCOUNT_GET_USERS =                    "account.get_users" #OK
ADMIN_ACCOUNT_GET_MEMBERS =                  "account.get_members" #OK
ADMIN_ACCOUNT_ASSIGN_USER =                  "account.assign_user" #OK
ADMIN_ACCOUNT_UNASSIGN_USER =                "account.unassign_user" #OK
ADMIN_ACCOUNT_GET_WALLETS =                  "account.get_wallets" #OK
ADMIN_ACCOUNT_GET_CONSUMPTIONS =             "account.get_transaction_consumptions" #OK

### Wallets
ADMIN_WALLET_ALL =                           "wallet.all" #OK
ADMIN_WALLET_CREATE =                        "wallet.create" #OK
ADMIN_WALLET_GET =                           "wallet.get" #OK
ADMIN_WALLET_GET_CONSUMPTIONS =              "wallet.get_transaction_consumptions" #OK

### Transaction
ADMIN_TRANSACTION_ALL =                      "transaction.all" #OK
ADMIN_TRANSACTION_GET =                      "transaction.get" #OK
ADMIN_TRANSACTION_CREATE =                   "transaction.create" #OK

### Transaction Request
ADMIN_TRANSACTION_REQUEST_CREATE =           "transaction_request.create" #OK
ADMIN_TRANSACTION_REQUEST_GET =              "transaction_request.get" #OK
ADMIN_TRANSACTION_REQUEST_CONSUME =          "transaction_request.consume" #OK
ADMIN_TRANSACTION_REQUEST_ALL =              "transaction_request.all" #OK
ADMIN_TRANSACTION_REQUEST_GET_CONSUMPTIONS = "transaction_request.get_transaction_consumptions" #OK

### Transaction Consumption
ADMIN_TRANSACTION_CONSUMPTION_APPROVE =      "transaction_consumption.approve" #OK
ADMIN_TRANSACTION_CONSUMPTION_REJECT =       "transaction_consumption.reject" #OK
ADMIN_TRANSACTION_CONSUMPTION_ALL =          "transaction_consumption.all" #OK
ADMIN_TRANSACTION_CONSUMPTION_GET =          "transaction_consumption.get" #OK

### API keys
ADMIN_KEY_ACCESS_ALL =                       "access_key.all" #OK
ADMIN_KEY_ACCESS_CREATE =                    "access_key.create" #OK
ADMIN_KEY_ACCESS_DELETE =                    "access_key.delete" #OK
ADMIN_KEY_API_ALL =                          "api_key.all" #OK
ADMIN_KEY_API_CREATE =                       "api_key.create" #OK
ADMIN_KEY_API_DELETE =                       "api_key.delete" #OK

### Exchange pairs
ADMIN_EXCHANGE_PAIR_ALL =                    "exchange_pair.all" #OK
ADMIN_EXCHANGE_PAIR_GET =                    "exchange_pair.get" #OK
ADMIN_EXCHANGE_PAIR_CREATE =                 "exchange_pair.create" #OK
ADMIN_EXCHANGE_PAIR_UPDATE =                 "exchange_pair.update" #OK
ADMIN_EXCHANGE_PAIR_DELETE =                 "exchange_pair.delete" #OK

### Settings
ADMIN_GET_SETTINGS =                         "settings.all" #OK

## Client

### Session
CLIENT_LOGOUT =                              "me.logout" #OK

### User
CLIENT_GET =                                 "me.get" #OK

### Wallet
CLIENT_GET_WALLETS =                         "me.get_wallets" #OK

### Transaction
CLIENT_GET_TRANSACTIONS =                    "me.get_transactions" #OK
CLIENT_CREATE_TRANSACTION =                  "me.create_transaction" #OK

### Transaction Request
CLIENT_TRANSACTION_REQUEST_CREATE =          "me.create_transaction_request" #OK
CLIENT_TRANSACTION_REQUEST_GET =             "me.get_transaction_request" #OK
CLIENT_TRANSACTION_REQUEST_CONSUME =         "me.consume_transaction_request" #OK

### Transaction Consumption
CLIENT_TRANSACTION_CONSUMPTION_APPROVE =     "me.approve_transaction_consumption" #OK
CLIENT_TRANSACTION_CONSUMPTION_REJECT =      "me.reject_transaction_consumption" #OK

### Settings
CLIENT_GET_SETTINGS =                        "me.get_settings" #OK



## List of all test generated global variables:
# MASTER_ACCOUNT_ID = The id of the master account
# ADMIN_USER_AUTHENTICATION = The built admin 'Authorization' header
# TOKEN_ID = The first created token ID
# TOKEN_1_ID = The second created token ID
# ACCOUNT_ID = The created account ID
# ADMIN_1_ID = The second admin ID
# MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS = The wallet address of the master account
# SERVER_AUTHENTICATION = The built server 'Authorization' header
# API_KEY = The created api key (used to build the client authentication)
# PROVIDER_USER_ID = The first created user provider id
# PROVIDER_USER_1_ID = The second created user provider id
# USER_PRIMARY_WALLET_ADDRESS = The primary wallet address of the PROVIDER_USER_ID user
# CLIENT_AUTHENTICATION = The first built client 'Authorization' header
# CLIENT_1_AUTHENTICATION = The second built client 'Authorization' header
# T_REQUEST_1_FID
# T_REQUEST_2_FID
# T_REQUEST_3_FID
# T_REQUEST_4_FID
# T_REQUEST_5_FID
# T_REQUEST_6_FID
# T_REQUEST_7_FID
# ^^^^^^^^^^^^^^^^ These are all transaction requests that we create and consume
