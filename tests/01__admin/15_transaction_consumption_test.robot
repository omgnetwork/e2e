*** Settings ***
Documentation     Tests related to the consumption of transaction requests
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot
Library           WebSocketClient

*** Test Cases ***
Consume transaction request 1 successfully with an exchange_account_id
    ${data}    Get Binary File    ${RESOURCE}/consume_transaction_request_with_exchange_account_id.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    formatted_transaction_request_id=${T_REQUEST_1_FID}    token_id=${TOKEN_1_ID}    address=${USER_PRIMARY_WALLET_ADDRESS}    exchange_account_id=${MASTER_ACCOUNT_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CONSUME}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_consumption
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['status']}    confirmed
    Should be Equal    ${resp.json()['data']['address']}    ${json_data['address']}

Consume transaction request 2 successfully with the same token
    ${data}    Get Binary File    ${RESOURCE}/consume_transaction_request_address.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    formatted_transaction_request_id=${T_REQUEST_2_FID}    token_id=${TOKEN_ID}    address=${USER_PRIMARY_WALLET_ADDRESS}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CONSUME}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_consumption
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['status']}    confirmed
    Should be Equal    ${resp.json()['data']['address']}    ${json_data['address']}

Consume transaction request 3 successfully with an account_id
    ${data}    Get Binary File    ${RESOURCE}/consume_transaction_request_account.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    formatted_transaction_request_id=${T_REQUEST_3_FID}    token_id=${TOKEN_ID}    account_id=${ACCOUNT_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CONSUME}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_consumption
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['status']}    confirmed
    Should be Equal    ${resp.json()['data']['account_id']}    ${json_data['account_id']}

Consume transaction request 4 successfully with a provider_user_id
    ${data}    Get Binary File    ${RESOURCE}/consume_transaction_request_user.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    formatted_transaction_request_id=${T_REQUEST_4_FID}    token_id=${TOKEN_ID}    provider_user_id=${PROVIDER_USER_1_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CONSUME}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_consumption
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['status']}    confirmed
    Should be Equal    ${resp.json()['data']['user']['provider_user_id']}    ${json_data['provider_user_id']}

Consume transaction request 5 successfully with an amount
    ${data}    Get Binary File    ${RESOURCE}/consume_transaction_request_amount.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    formatted_transaction_request_id=${T_REQUEST_5_FID}    token_id=${TOKEN_ID}    address=${USER_PRIMARY_WALLET_ADDRESS}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CONSUME}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_consumption
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['status']}    confirmed
    Should be Equal    ${resp.json()['data']['address']}    ${json_data['address']}
    Should be Equal    ${resp.json()['data']['amount']}    ${json_data['amount']}

Consume transaction request 6 successfully with an exchange_account_id in the request and a different token
    ${data}    Get Binary File    ${RESOURCE}/consume_transaction_request_address.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    formatted_transaction_request_id=${T_REQUEST_6_FID}    token_id=${TOKEN_1_ID}    address=${USER_PRIMARY_WALLET_ADDRESS}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CONSUME}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_consumption
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['status']}    confirmed
    Should be Equal    ${resp.json()['data']['address']}    ${json_data['address']}

Consume transaction request 7 successfully with an exchange_wallet_address in the consumption and a different token
    ${data}    Get Binary File    ${RESOURCE}/consume_transaction_request_with_exchange_address.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    formatted_transaction_request_id=${T_REQUEST_7_FID}    token_id=${TOKEN_1_ID}    address=${USER_PRIMARY_WALLET_ADDRESS}    exchange_wallet_address=${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CONSUME}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_consumption
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['status']}    confirmed
    Should be Equal    ${resp.json()['data']['address']}    ${json_data['address']}
