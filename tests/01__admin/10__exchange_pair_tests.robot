*** Settings ***
Documentation     Tests related to exchange pairs
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot

*** Variables ***
${JSON_PATH}      ${RESOURCE_PATH}/exchange_pair

*** Test Cases ***
Create an exchange pair successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/create_exchange_pair.json
    &{override}    Create Dictionary    from_token_id=${TOKEN_ID}    to_token_id=${TOKEN_1_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXCHANGE_PAIR_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    ${pair}    Get From List    ${resp.json()['data']['data']}    0
    Should be Equal    ${pair['rate']}    ${json_data['rate']}
    Should be Equal    ${pair['from_token_id']}    ${json_data['from_token_id']}
    Should be Equal    ${pair['to_token_id']}    ${json_data['to_token_id']}
    ${EXCHANGE_PAIR_ID}    Get Variable Value    ${pair['id']}
    Set Suite Variable    ${EXCHANGE_PAIR_ID}

Get all exchange pairs successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_exchange_pairs.json
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXCHANGE_PAIR_ALL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}

Update an exchange pair successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_exchange_pair.json
    ${data}    Update Json    ${data}    id=${EXCHANGE_PAIR_ID}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXCHANGE_PAIR_UPDATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    ${pair}    Get From List    ${resp.json()['data']['data']}    0
    Should be Equal    ${pair['id']}    ${json_data['id']}
    Should be Equal    ${pair['rate']}    ${json_data['rate']}

Get an exchange pair successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_exchange_pair.json
    ${data}    Update Json    ${data}    id=${EXCHANGE_PAIR_ID}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXCHANGE_PAIR_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    exchange_pair
    Should Be Equal    ${resp.json()['data']['id']}    ${EXCHANGE_PAIR_ID}

Delete an exchange pair successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/delete_exchange_pair.json
    ${data}    Update Json    ${data}    id=${EXCHANGE_PAIR_ID}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXCHANGE_PAIR_DELETE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    ${pair}    Get From List    ${resp.json()['data']['data']}    0
    Should Be Equal    ${pair['id']}    ${EXCHANGE_PAIR_ID}
    #Re-create it for later tests:
    ${data}    Get Binary File    ${JSON_PATH}/create_exchange_pair.json
    &{override}    Create Dictionary    from_token_id=${TOKEN_ID}    to_token_id=${TOKEN_1_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXCHANGE_PAIR_CREATE}    data=${data}    headers=${headers}
