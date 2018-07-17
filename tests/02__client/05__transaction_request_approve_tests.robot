*** Settings ***
Documentation     Tests related to transaction requests and consumptions
Suite Setup       Create Client API Session
Suite Teardown    Delete All Sessions
Resource          client_resources.robot
Library           WebSocketClient

*** Test Cases ***
Create a transaction request successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/create_transaction_request.json
    ${correlation_id}    Generate Random String
    &{override}    Create Dictionary    token_id=${TOKEN_ID}    correlation_id=${correlation_id}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Request Header
    # Perform request
    ${resp}    Post Request    api    ${CLIENT_TRANSACTION_REQUEST_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_request
    Should be Equal    ${resp.json()['data']['token_id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['status']}    valid
    Should be Equal    ${resp.json()['data']['type']}    ${json_data['type']}
    Should be Equal    ${resp.json()['data']['allow_amount_override']}    ${json_data['allow_amount_override']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}    ${json_data['metadata']}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}    ${json_data['encrypted_metadata']}
    ${TRANSACTION_REQUEST_FORMATTED_ID}    Get Variable Value    ${resp.json()['data']['formatted_id']}
    Set Suite Variable    ${TRANSACTION_REQUEST_FORMATTED_ID}
    ${TRANSACTION_REQUEST_SOCKET_TOPIC}    Get Variable Value    ${resp.json()['data']['socket_topic']}
    Set Suite Variable    ${TRANSACTION_REQUEST_SOCKET_TOPIC}

Get a transaction request successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/get_transaction_request.json
    ${data}    Update Json    ${data}    formatted_id=${TRANSACTION_REQUEST_FORMATTED_ID}
    &{headers}    Build Authenticated Request Header
    # Perform request
    ${resp}    Post Request    api    ${CLIENT_TRANSACTION_REQUEST_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_request
    Should be Equal    ${resp.json()['data']['formatted_id']}    ${TRANSACTION_REQUEST_FORMATTED_ID}

Join transaction request channel successfully
    &{headers}    Build Authenticated Request Header
    ${WEBSOCKET_REQUEST}    WebSocketClient.Connect    ${CLIENT_SOCKET_HOST}    header=${headers}
    Set Suite Variable    ${WEBSOCKET_REQUEST}
    ${data}    Get Binary File    ${RESOURCE}/join_channel.json
    &{override}    Create Dictionary    ref=1    topic=${TRANSACTION_REQUEST_SOCKET_TOPIC}
    ${data}    Update Json    ${data}    &{override}
    ${data_string}    Convert To String    ${data}
    WebSocketClient.Send    ${WEBSOCKET_REQUEST}    ${data_string}
    ${resp_string}    WebSocketClient.Recv    ${WEBSOCKET_REQUEST}
    ${resp}    To Json    ${resp_string}
    Should be true    ${resp['success']}
    Should Be Equal    ${resp['topic']}    ${TRANSACTION_REQUEST_SOCKET_TOPIC}

Consume transaction request successfully as an admin
    ${data}    Get Binary File    ${RESOURCE}/consume_transaction_request.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    formatted_transaction_request_id=${TRANSACTION_REQUEST_FORMATTED_ID}    token_id=${TOKEN_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    # Build authentication headers for 2nd user
    &{headers}    Build Secondary Authenticated Request Header
    # Perform request
    ${resp}    Post Request    api    ${CLIENT_TRANSACTION_REQUEST_CONSUME}    data=${data}    headers=${headers}
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
    ${resp_string}    WebSocketClient.Recv    ${WEBSOCKET_REQUEST}
    ${socket_resp}    To Json    ${resp_string}
    Should be true    ${socket_resp['success']}
    Should Be Equal    ${socket_resp['topic']}    ${TRANSACTION_REQUEST_SOCKET_TOPIC}
    Should Be Equal    ${socket_resp['event']}    transaction_consumption_request
    Should Be Equal    ${socket_resp['data']['transaction_request']['formatted_id']}    ${TRANSACTION_REQUEST_FORMATTED_ID}
    Should Be Equal    ${socket_resp['data']['token_id']}    ${TOKEN_ID}
    Should Be Equal    ${socket_resp['data']['status']}    pending

Join transaction consumption channel successfully
    &{headers}    Build Secondary Authenticated Request Header
    ${WEBSOCKET_CONSUMPTION}    WebSocketClient.Connect    ${CLIENT_SOCKET_HOST}    header=${headers}
    Set Suite Variable    ${WEBSOCKET_CONSUMPTION}
    ${data}    Get Binary File    ${RESOURCE}/join_channel.json
    &{override}    Create Dictionary    ref=1    topic=${TRANSACTION_CONSUMPTION_SOCKET_TOPIC}
    ${data}    Update Json    ${data}    &{override}
    ${data_string}    Convert To String    ${data}
    WebSocketClient.Send    ${WEBSOCKET_CONSUMPTION}    ${data_string}
    ${resp_string}    WebSocketClient.Recv    ${WEBSOCKET_CONSUMPTION}
    ${resp}    To Json    ${resp_string}
    Should be true    ${resp['success']}
    Should Be Equal    ${resp['topic']}    ${TRANSACTION_CONSUMPTION_SOCKET_TOPIC}

Approve transaction consumption successfully
    ${data}    Get Binary File    ${RESOURCE}/approve_transaction_consumption.json
    ${data}    Update Json    ${data}    id=${TRANSACTION_CONSUMPTION_ID}
    # Build authentication headers
    &{headers}    Build Authenticated Request Header
    # Perform request
    ${resp}    Post Request    api    ${CLIENT_TRANSACTION_CONSUMPTION_APPROVE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_consumption
    Should Be Equal    ${resp.json()['data']['id']}    ${TRANSACTION_CONSUMPTION_ID}
    Should be Equal    ${resp.json()['data']['token_id']}    ${TOKEN_ID}
    Should be Equal    ${resp.json()['data']['status']}    confirmed
    ${resp_string}    WebSocketClient.Recv    ${WEBSOCKET_CONSUMPTION}
    ${socket_resp}    To Json    ${resp_string}
    Should be true    ${socket_resp['success']}
    Should Be Equal    ${socket_resp['topic']}    ${TRANSACTION_CONSUMPTION_SOCKET_TOPIC}
    Should Be Equal    ${socket_resp['event']}    transaction_consumption_finalized
    Should Be Equal    ${socket_resp['data']['id']}    ${TRANSACTION_CONSUMPTION_ID}
    Should Be Equal    ${socket_resp['data']['token_id']}    ${TOKEN_ID}
    Should Be Equal    ${socket_resp['data']['status']}    confirmed
