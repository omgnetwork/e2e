*** Settings ***
Documentation     Tests related to the retrieval of transaction requests
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot
Library           WebSocketClient

*** Variables ***
${JSON_PATH}      ${RESOURCE_PATH}/transaction_request

*** Test Cases ***
Get a transaction request successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_transaction_request.json
    ${data}    Update Json    ${data}    formatted_id=${T_REQUEST_1_FID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_request
    Should be Equal    ${resp.json()['data']['formatted_id']}    ${T_REQUEST_1_FID}

Get all transaction request successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_transaction_requests.json
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_ALL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}
