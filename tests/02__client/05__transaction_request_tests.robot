*** Settings ***
Documentation    Tests related to transaction requests and consumptions

Resource    client_resources.robot

Suite Setup     Create Client API Session
Suite Teardown  Delete All Sessions

Library  WebSocketClient

*** Test Cases ***
Create a transaction request successfully
    # Build payload
    ${data}              Get Binary File      ${RESOURCE}/create_transaction_request.json
    ${correlation_id}    Generate Random String
    &{override}          Create Dictionary    token_id=${TOKEN_ID}
    ...                                       correlation_id=${correlation_id}
    ${data}              Update Json          ${data}    &{override}
    ${json_data}         To Json              ${data}
    &{headers}           Build Authenticated Request Header

    # Perform request
    ${resp}    Post Request    api    ${CLIENT_TRANSACTION_REQUEST_CREATE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success         ${resp}
    Assert Object Type              ${resp}    transaction_request
    Should be Equal                 ${resp.json()['data']['token_id']}                 ${json_data['token_id']}
    Should be Equal                 ${resp.json()['data']['amount']}                   ${json_data['amount']}
    Should be Equal                 ${resp.json()['data']['status']}                   valid
    Should be Equal                 ${resp.json()['data']['type']}                     ${json_data['type']}
    Should be Equal                 ${resp.json()['data']['allow_amount_override']}    ${json_data['allow_amount_override']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}                 ${json_data['metadata']}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}       ${json_data['encrypted_metadata']}

    ${TRANSACTION_REQUEST_FORMATTED_ID}    Get Variable Value    ${resp.json()['data']['formatted_id']}
    Set Suite Variable                     ${TRANSACTION_REQUEST_FORMATTED_ID}

    ${TRANSACTION_REQUEST_SOCKET_TOPIC}    Get Variable Value    ${resp.json()['data']['socket_topic']}
    Set Suite Variable                     ${TRANSACTION_REQUEST_SOCKET_TOPIC}

Get a transaction request successfully
    # Build payload
    ${data}              Get Binary File      ${RESOURCE}/get_transaction_request.json
    ${data}              Update Json          ${data}    formatted_id=${TRANSACTION_REQUEST_FORMATTED_ID}
    &{headers}           Build Authenticated Request Header

    # Perform request
    ${resp}    Post Request    api    ${CLIENT_TRANSACTION_REQUEST_GET}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    transaction_request
    Should be Equal            ${resp.json()['data']['formatted_id']}    ${TRANSACTION_REQUEST_FORMATTED_ID}

Join transaction request channel successfully
    &{headers}            Build Authenticated Request Header
    ${WEBSOCKET}          WebSocketClient.Connect    ${SOCKET_HOST}    header=${headers}
    Set Suite Variable    ${WEBSOCKET}

    ${data}              Get Binary File      ${RESOURCE}/join_channel.json
    ${ref}               Generate Random String
    &{override}          Create Dictionary    ref=${ref}
    ...                                       topic=${TRANSACTION_REQUEST_SOCKET_TOPIC}
    ${data}              Update Json          ${data}    &{override}
    ${data_string}       Convert To String     ${data}

    WebSocketClient.Send       ${WEBSOCKET}            ${data_string}
    ${resp_string}             WebSocketClient.Recv    ${WEBSOCKET}
    ${resp}                    To Json                 ${resp_string}
    Should be true             ${resp['success']}
    Should Be Equal            ${resp['topic']}        ${TRANSACTION_REQUEST_SOCKET_TOPIC}

Consume transaction request successfully as an admin
    ${data}              Get Binary File      ${RESOURCE}/consume_transaction_request.json
    ${i_token}           Generate Random String
    &{override}          Create Dictionary    idempotency_token=${i_token}
    ...                                       formatted_transaction_request_id=${TRANSACTION_REQUEST_FORMATTED_ID}
    ...                                       token_id=${TOKEN_ID}
    ${data}              Update Json          ${data}    &{override}

    ${json_data}         To Json              ${data}

    # Build authentication headers for 2nd user
    &{headers}           Build Secondary Authenticated Request Header

    # Perform request
    ${resp}    Post Request    api    ${CLIENT_TRANSACTION_REQUEST_CONSUME}    data=${data}    headers=${headers}
    Log To Console    ${resp.json()}

    # Assert response
    Assert Response Success         ${resp}
    Assert Object Type              ${resp}    transaction_consumption
    Should be Equal                 ${resp.json()['data']['token_id']}                 ${json_data['token_id']}
    Should be Equal                 ${resp.json()['data']['status']}                   confirmed
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}                 ${json_data['metadata']}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}       ${json_data['encrypted_metadata']}

    ${TRANSACTION_CONSUMPTION_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Suite Variable               ${TRANSACTION_CONSUMPTION_ID}

    ${TRANSACTION_CONSUMPTION_SOCKET_TOPIC}    Get Variable Value    ${resp.json()['data']['socket_topic']}
    Set Suite Variable                         ${TRANSACTION_CONSUMPTION_SOCKET_TOPIC}

    ${resp_string}             WebSocketClient.Recv    ${WEBSOCKET}
    Log To Console    ${resp_string}
