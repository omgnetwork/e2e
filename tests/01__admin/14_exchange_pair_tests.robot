*** Settings ***
Documentation     Tests related to exchange pairs
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot

*** Test Cases ***
Create an exchange pair successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/create_exchange_pair.json
    ${name}    Generate Random String
    &{override}    Create Dictionary    name=${name}    from_token_id=${TOKEN_ID}    to_token_id=${TOKEN_1_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXCHANGE_PAIR_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    exchange_pair
    Should be Equal    ${resp.json()['data']['name']}    ${json_data['name']}
    Should be Equal    ${resp.json()['data']['rate']}    ${json_data['rate']}
    Should be Equal    ${resp.json()['data']['from_token_id']}    ${json_data['from_token_id']}
    Should be Equal    ${resp.json()['data']['to_token_id']}    ${json_data['to_token_id']}
    ${EXCHANGE_PAIR_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Suite Variable    ${EXCHANGE_PAIR_ID}

Get all exchange pairs successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/get_exchange_pairs.json
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXCHANGE_PAIR_ALL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}

Update an exchange pair successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/update_exchange_pair.json
    ${name}    Generate Random String
    ${data}    Update Json    ${data}    id=${EXCHANGE_PAIR_ID}    name=${name}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXCHANGE_PAIR_UPDATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    exchange_pair
    Should be Equal    ${resp.json()['data']['id']}    ${json_data['id']}
    Should be Equal    ${resp.json()['data']['name']}    ${json_data['name']}
    Should be Equal    ${resp.json()['data']['rate']}    ${json_data['rate']}

Get an exchange pair successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/get_exchange_pair.json
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
    ${data}    Get Binary File    ${RESOURCE}/delete_exchange_pair.json
    ${data}    Update Json    ${data}    id=${EXCHANGE_PAIR_ID}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXCHANGE_PAIR_DELETE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    exchange_pair
    Should Be Equal    ${resp.json()['data']['id']}    ${EXCHANGE_PAIR_ID}
