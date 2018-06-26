*** Settings ***
Documentation     Tests related to tokens
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot

*** Test Cases ***
Create a token successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/create_token.json
    ${name}    Generate Random String
    ${symbol}    Generate Random String    3
    ${data}    Update Json    ${data}    name=${name}    symbol=${symbol}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TOKEN_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    token
    Should be Equal    ${resp.json()['data']['symbol']}    ${json_data['symbol']}
    Should be Equal    ${resp.json()['data']['name']}    ${json_data['name']}
    Should be Equal    ${resp.json()['data']['subunit_to_unit']}    ${json_data['subunit_to_unit']}
    Should be Equal    ${resp.json()['data']['symbol']}    ${json_data['symbol']}
    ${TOKEN_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Global Variable    ${TOKEN_ID}
    # Create an other token for using with exchange pairs
    ${name}    Generate Random String
    ${symbol}    Generate Random String    3
    ${data}    Update Json    ${data}    name=${name}    symbol=${symbol}
    ${resp}    Post Request    api    ${ADMIN_TOKEN_CREATE}    data=${data}    headers=${headers}
    ${TOKEN_1_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Global Variable    ${TOKEN_1_ID}

Mint a token successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/mint_token.json
    ${data}    Update Json    ${data}    id=${TOKEN_ID}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TOKEN_MINT}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    mint
    Should be Equal    ${resp.json()['data']['token_id']}    ${TOKEN_ID}
    Should be Equal    ${resp.json()['data']['amount']}    ${json_data['amount']}

Get a token successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/get_token.json
    ${data}    Update Json    ${data}    id=${TOKEN_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TOKEN_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    token
    Should be Equal    ${resp.json()['data']['id']}    ${TOKEN_ID}

Get all tokens successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/get_tokens.json
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TOKEN_LIST}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}

Get stats successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/get_token_stats.json
    ${data}    Update Json    ${data}    id=${TOKEN_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TOKEN_STATS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    token_stats
    Should Be Equal    ${resp.json()['data']['token_id']}    ${TOKEN_ID}

Get mints successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/get_mints.json
    ${data}    Update Json    ${data}    id=${TOKEN_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TOKEN_GET_MINTS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}
