*** Settings ***
Documentation     Tests related to the retrieval of transaction consumptions
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot
Library           WebSocketClient

*** Variables ***
${JSON_PATH}      ${RESOURCE_PATH}/transaction_consumption

*** Test Cases ***
Get consumptions for an account successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_consumptions_of_account.json
    ${data}    Update Json    ${data}    id=${MASTER_ACCOUNT_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET_CONSUMPTIONS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    ${transaction_consumption}    Get From List    ${resp.json()['data']['data']}    0
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}
    ${TRANSACTION_CONSUMPTION_ID}    Get Variable Value    ${transaction_consumption['id']}
    Set Suite Variable    ${TRANSACTION_CONSUMPTION_ID}

Get consumptions of transaction request successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_consumptions_of_request.json
    ${data}    Update Json    ${data}    formatted_transaction_request_id=${T_REQUEST_1_FID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_GET_CONSUMPTIONS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}

Get consumption successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_consumption.json
    ${data}    Update Json    ${data}    id=${TRANSACTION_CONSUMPTION_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_CONSUMPTION_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_consumption
    Should be Equal    ${resp.json()['data']['id']}    ${TRANSACTION_CONSUMPTION_ID}

Get all consumptions successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_consumptions.json
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_CONSUMPTION_ALL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}

Get consumptions for a wallet successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_consumptions_of_wallet.json
    ${data}    Update Json    ${data}    address=${USER_PRIMARY_WALLET_ADDRESS}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_WALLET_GET_CONSUMPTIONS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}

Get consumptions for a user successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_consumptions_of_user.json
    ${data}    Update Json    ${data}    provider_user_id=${PROVIDER_USER_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_USER_GET_CONSUMPTIONS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}
