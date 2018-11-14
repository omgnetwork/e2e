*** Settings ***
Documentation     Tests related to wallets
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot

*** Variables ***
${JSON_PATH}      ${RESOURCE_PATH}/wallet

*** Test Cases ***
Create a wallet successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/create_wallet.json
    ${name}    Generate Random String
    &{override}    Create Dictionary    name=${name}    account_id=${ACCOUNT_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_WALLET_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    wallet
    Should be Equal    ${resp.json()['data']['name']}    ${json_data['name']}
    Should be Equal    ${resp.json()['data']['account_id']}    ${json_data['account_id']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}    ${json_data['metadata']}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}    ${json_data['encrypted_metadata']}
    ${WALLET_ADDRESS}    Get Variable Value    ${resp.json()['data']['address']}
    Set Suite Variable    ${WALLET_ADDRESS}

Get all wallets successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_wallets.json
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_WALLET_ALL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}

Get a wallet successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_wallet.json
    ${data}    Update Json    ${data}    address=${WALLET_ADDRESS}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_WALLET_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    wallet
    Should Be Equal    ${resp.json()['data']['address']}    ${WALLET_ADDRESS}

Disable a wallet successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/enable_or_disable.json
    ${data}    Update Json    ${data}    address=${WALLET_ADDRESS}    enabled=${FALSE}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_WALLET_ENABLE_OR_DISABLE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    wallet
    Should be Equal    ${resp.json()['data']['address']}    ${WALLET_ADDRESS}
    Should Not Be True    ${resp.json()['data']['enabled']}

Disable a wallet fails if address does not exist
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/enable_or_disable.json
    ${data}    Update Json    ${data}    address=invalid_address    enabled=${FALSE}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_WALLET_ENABLE_OR_DISABLE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    unauthorized
    Should be Equal    ${resp.json()['data']['description']}    You are not allowed to perform the requested operation.

Enable a wallet successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/enable_or_disable.json
    ${data}    Update Json    ${data}    address=${WALLET_ADDRESS}    enabled=${TRUE}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_WALLET_ENABLE_OR_DISABLE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    wallet
    Should be Equal    ${resp.json()['data']['address']}    ${WALLET_ADDRESS}
    Should Be True    ${resp.json()['data']['enabled']}
