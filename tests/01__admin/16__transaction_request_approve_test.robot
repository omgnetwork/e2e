*** Settings ***
Documentation     Tests related to the flow (using websockets) of request/consumption approval
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot
Library           WebSocketClient

*** Variables ***
${JSON_REQUEST_PATH}    ${RESOURCE_PATH}/transaction_request
${JSON_CONSUMPTION_PATH}    ${RESOURCE_PATH}/transaction_consumption
${JSON_SOCKET_PATH}    ${RESOURCE_PATH}/socket

*** Test Cases ***
Create a transaction request successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_REQUEST_PATH}/create_transaction_request_with_confirmation.json
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
    Should be Equal    ${resp.json()['data']['status']}    valid
    ${TRANSACTION_REQUEST_FORMATTED_ID}    Get Variable Value    ${resp.json()['data']['formatted_id']}
    Set Suite Variable    ${TRANSACTION_REQUEST_FORMATTED_ID}
    ${TRANSACTION_REQUEST_SOCKET_TOPIC}    Get Variable Value    ${resp.json()['data']['socket_topic']}
    Set Suite Variable    ${TRANSACTION_REQUEST_SOCKET_TOPIC}

Join transaction request channel successfully
    &{headers}    Build Authenticated Admin Request Header
    ${WEBSOCKET_ADMIN}    WebSocketClient.Connect    ${ADMIN_SOCKET_HOST}    header=${headers}
    Set Suite Variable    ${WEBSOCKET_ADMIN}
    ${data}    Get Binary File    ${JSON_SOCKET_PATH}/join_channel.json
    &{override}    Create Dictionary    ref=1    topic=${TRANSACTION_REQUEST_SOCKET_TOPIC}
    ${data}    Update Json    ${data}    &{override}
    ${data_string}    Convert To String    ${data}
    WebSocketClient.Send    ${WEBSOCKET_ADMIN}    ${data_string}
    ${resp_string}    WebSocketClient.Recv    ${WEBSOCKET_ADMIN}
    ${resp}    To Json    ${resp_string}
    Should be true    ${resp['success']}
    Should Be Equal    ${resp['topic']}    ${TRANSACTION_REQUEST_SOCKET_TOPIC}

Consume transaction request successfully as an admin
    ${data}    Get Binary File    ${JSON_CONSUMPTION_PATH}/consume_transaction_request_address.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    formatted_transaction_request_id=${TRANSACTION_REQUEST_FORMATTED_ID}    token_id=${TOKEN_ID}    address=${USER_PRIMARY_WALLET_ADDRESS}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_REQUEST_CONSUME}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_consumption
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['status']}    pending
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}    ${json_data['metadata']}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}    ${json_data['encrypted_metadata']}
    ${TRANSACTION_CONSUMPTION_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Suite Variable    ${TRANSACTION_CONSUMPTION_ID}
    ${TRANSACTION_CONSUMPTION_SOCKET_TOPIC}    Get Variable Value    ${resp.json()['data']['socket_topic']}
    Set Suite Variable    ${TRANSACTION_CONSUMPTION_SOCKET_TOPIC}
    ${resp_string}    WebSocketClient.Recv    ${WEBSOCKET_ADMIN}
    ${socket_resp}    To Json    ${resp_string}
    Should be true    ${socket_resp['success']}
    Should Be Equal    ${socket_resp['topic']}    ${TRANSACTION_REQUEST_SOCKET_TOPIC}
    Should Be Equal    ${socket_resp['event']}    transaction_consumption_request
    Should Be Equal    ${socket_resp['data']['transaction_request']['formatted_id']}    ${TRANSACTION_REQUEST_FORMATTED_ID}
    Should Be Equal    ${socket_resp['data']['token_id']}    ${TOKEN_ID}
    Should Be Equal    ${socket_resp['data']['status']}    pending

Join transaction consumption channel successfully
    Set Suite Variable    ${WEBSOCKET_ADMIN}
    ${data}    Get Binary File    ${JSON_SOCKET_PATH}/join_channel.json
    &{override}    Create Dictionary    ref=2    topic=${TRANSACTION_CONSUMPTION_SOCKET_TOPIC}
    ${data}    Update Json    ${data}    &{override}
    ${data_string}    Convert To String    ${data}
    WebSocketClient.Send    ${WEBSOCKET_ADMIN}    ${data_string}
    ${resp_string}    WebSocketClient.Recv    ${WEBSOCKET_ADMIN}
    ${resp}    To Json    ${resp_string}
    Should be true    ${resp['success']}
    Should Be Equal    ${resp['topic']}    ${TRANSACTION_CONSUMPTION_SOCKET_TOPIC}

Approve transaction consumption successfully
    ${data}    Get Binary File    ${JSON_CONSUMPTION_PATH}/approve_transaction_consumption.json
    ${data}    Update Json    ${data}    id=${TRANSACTION_CONSUMPTION_ID}
    # Build authentication headers
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_CONSUMPTION_APPROVE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_consumption
    Should Be Equal    ${resp.json()['data']['id']}    ${TRANSACTION_CONSUMPTION_ID}
    Should be Equal    ${resp.json()['data']['token_id']}    ${TOKEN_ID}
    Should be Equal    ${resp.json()['data']['status']}    confirmed
    ${resp_string_trx_request}    WebSocketClient.Recv    ${WEBSOCKET_ADMIN}
    ${socket_resp}    To Json    ${resp_string_trx_request}
    Should be true    ${socket_resp['success']}
    Should Be Equal    ${socket_resp['topic']}    ${TRANSACTION_REQUEST_SOCKET_TOPIC}
    Should Be Equal    ${socket_resp['event']}    transaction_consumption_finalized
    Should Be Equal    ${socket_resp['data']['id']}    ${TRANSACTION_CONSUMPTION_ID}
    Should Be Equal    ${socket_resp['data']['token_id']}    ${TOKEN_ID}
    Should Be Equal    ${socket_resp['data']['status']}    confirmed
    ${resp_string_trx_consumption}    WebSocketClient.Recv    ${WEBSOCKET_ADMIN}
    ${socket_resp}    To Json    ${resp_string_trx_consumption}
    Should be true    ${socket_resp['success']}
    Should Be Equal    ${socket_resp['topic']}    ${TRANSACTION_CONSUMPTION_SOCKET_TOPIC}
    Should Be Equal    ${socket_resp['event']}    transaction_consumption_finalized
    Should Be Equal    ${socket_resp['data']['id']}    ${TRANSACTION_CONSUMPTION_ID}
    Should Be Equal    ${socket_resp['data']['token_id']}    ${TOKEN_ID}
    Should Be Equal    ${socket_resp['data']['status']}    confirmed
