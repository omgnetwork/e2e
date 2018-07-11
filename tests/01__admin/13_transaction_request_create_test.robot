*** Settings ***
Documentation     Tests related to transaction requests and consumptions
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot
Library           WebSocketClient

*** Test Cases ***
Create a transaction request with a 'send' type successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/create_transaction_request_send.json
    ${correlation_id}    Generate Random String
    &{override}    Create Dictionary    address=${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}    token_id=${TOKEN_ID}    correlation_id=${correlation_id}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_request
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['address']}    ${json_data['address']}
    Should be Equal    ${resp.json()['data']['status']}    valid
    Should be Equal    ${resp.json()['data']['type']}    ${json_data['type']}

Create a transaction request with a 'receive' type successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/create_transaction_request_receive.json
    ${correlation_id}    Generate Random String
    &{override}    Create Dictionary    address=${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}    token_id=${TOKEN_ID}    correlation_id=${correlation_id}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_request
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['address']}    ${json_data['address']}
    Should be Equal    ${resp.json()['data']['status']}    valid
    Should be Equal    ${resp.json()['data']['type']}    ${json_data['type']}

Create a transaction request with an account_id successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/create_transaction_request_account_id.json
    ${correlation_id}    Generate Random String
    &{override}    Create Dictionary    account_id=${MASTER_ACCOUNT_ID}    token_id=${TOKEN_ID}    correlation_id=${correlation_id}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_request
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['account_id']}    ${json_data['account_id']}
    Should be Equal    ${resp.json()['data']['status']}    valid
    Should be Equal    ${resp.json()['data']['type']}    ${json_data['type']}

Create a transaction request with a provider_user_id successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/create_transaction_request_provider_user_id.json
    ${correlation_id}    Generate Random String
    &{override}    Create Dictionary    provider_user_id=${PROVIDER_USER_ID}    token_id=${TOKEN_ID}    correlation_id=${correlation_id}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_request
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['user']['provider_user_id']}    ${json_data['provider_user_id']}
    Should be Equal    ${resp.json()['data']['status']}    valid
    Should be Equal    ${resp.json()['data']['type']}    ${json_data['type']}

Create a transaction request without an amount successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/create_transaction_request_without_amount.json
    ${correlation_id}    Generate Random String
    &{override}    Create Dictionary    address=${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}    token_id=${TOKEN_ID}    correlation_id=${correlation_id}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_request
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should Be Equal    ${resp.json()['data']['amount']}    ${None}
    Should be Equal    ${resp.json()['data']['address']}    ${json_data['address']}
    Should be Equal    ${resp.json()['data']['status']}    valid

Create a transaction request with all possible parameters successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/create_transaction_request_all_params.json
    ${correlation_id}    Generate Random String
    &{override}    Create Dictionary    address=${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}    account_id=${MASTER_ACCOUNT_ID}    token_id=${TOKEN_ID}    correlation_id=${correlation_id}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CREATE}    data=${data}    headers=${headers}
    Log To Console    ${resp.json()}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_request
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['address']}    ${json_data['address']}
    Should be Equal    ${resp.json()['data']['account_id']}    ${json_data['account_id']}
    Should be Equal    ${resp.json()['data']['status']}    valid
    Should be Equal    ${resp.json()['data']['type']}    ${json_data['type']}
    Should be Equal    ${resp.json()['data']['require_confirmation']}    ${json_data['require_confirmation']}
    Should be Equal    ${resp.json()['data']['allow_amount_override']}    ${json_data['allow_amount_override']}
    Should be Equal    ${resp.json()['data']['max_consumptions']}    ${json_data['max_consumptions']}
    Should be Equal    ${resp.json()['data']['max_consumptions_per_user']}    ${json_data['max_consumptions_per_user']}
    Should be Equal    ${resp.json()['data']['consumption_lifetime']}    ${json_data['consumption_lifetime']}
    Should be Equal    ${resp.json()['data']['expiration_date']}    ${json_data['expiration_date']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}    ${json_data['metadata']}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}    ${json_data['encrypted_metadata']}
