*** Settings ***
Documentation     Tests related to accounts
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot

*** Test Cases ***
Create an account successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/create_account.json
    ${acc_name}    Generate Random String
    ${data}    Update Json    ${data}    name=${acc_name}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    account
    Should be Equal    ${resp.json()['data']['name']}    ${json_data['name']}
    Should be Equal    ${resp.json()['data']['description']}    ${json_data['description']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}    ${json_data['metadata']}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}    ${json_data['encrypted_metadata']}
    ${ACCOUNT_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Global Variable    ${ACCOUNT_ID}

Update an account successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/update_account.json
    ${acc_name}    Generate Random String
    &{updated_acc}    Create Dictionary    id=${ACCOUNT_ID}    name=${acc_name}
    ${data}    Update Json    ${data}    &{updated_acc}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_UPDATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    account
    Should be Equal    ${resp.json()['data']['id']}    ${ACCOUNT_ID}
    Should be Equal    ${resp.json()['data']['name']}    ${json_data['name']}
    Should be Equal    ${resp.json()['data']['description']}    ${json_data['description']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}    ${json_data['metadata']}
    Should Be Empty    ${resp.json()['data']['encrypted_metadata']}

Assign a user to an account successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/assign_user_to_account.json
    &{override}    Create Dictionary    email=${ADMIN_1_EMAIL}    account_id=${ACCOUNT_ID}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_ASSIGN_USER}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}

Get admins from an account successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/get_members_from_account.json
    ${data}    Update Json    ${data}    id=${ACCOUNT_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET_MEMBERS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    ${admin1}    Get From List    ${resp.json()['data']['data']}    0
    Should be Equal    ${admin1['email']}    ${ADMIN_1_EMAIL}
    ${ADMIN_1_ID}    Get Variable Value    ${admin1['id']}
    Set Global Variable    ${ADMIN_1_ID}

Unassign a user from an account successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/unassign_user_from_account.json
    &{override}    Create Dictionary    user_id=${ADMIN_1_ID}    account_id=${ACCOUNT_ID}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_UNASSIGN_USER}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}

List all wallets from an account successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/get_wallets_from_account.json
    ${data}    Update Json    ${data}    id=${MASTER_ACCOUNT_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET_WALLETS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}
    ${wallet}    Get From List    ${resp.json()['data']['data']}    0
    ${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}    Get Variable Value    ${wallet['address']}
    Set Global Variable    ${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}

Get an account successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/get_account.json
    ${data}    Update Json    ${data}    id=${ACCOUNT_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}

List all accounts successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/get_accounts.json
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_ALL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list

Switch token to account successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/switch_account.json
    ${data}    Update Json    ${data}    account_id=${ACCOUNT_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_SWITCH_ACCOUNT}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    authentication_token
    Should be Equal    ${resp.json()['data']['account_id']}    ${ACCOUNT_ID}
