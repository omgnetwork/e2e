*** Settings ***
Documentation    Tests related to users

Resource    admin_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Create user successfully
    # Build payload
    ${data}                Get Binary File    ${RESOURCE}/create_user.json
    ${PROVIDER_USER_ID}    Generate Random String
    ${username}            Generate Random String
    &{override}            Create Dictionary    provider_user_id=${PROVIDER_USER_ID}    username=${username}
    ${data}                Update Json        ${data}     &{override}

    Set Global Variable    ${PROVIDER_USER_ID}

    ${json_data}           To Json            ${data}

    &{headers}     Build Idempotent Authenticated Admin Request Header

    # Perform request
    ${resp}        Post Request    api    ${ADMIN_USER_CREATE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success         ${resp}
    Assert Object Type              ${resp}    user
    Should be Equal                 ${resp.json()['data']['provider_user_id']}      ${json_data['provider_user_id']}
    Should be Equal                 ${resp.json()['data']['username']}              ${json_data['username']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}              ${json_data['metadata']}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}    ${json_data['encrypted_metadata']}

Get user successfully
    # Build payload
    ${data}         Get Binary File    ${RESOURCE}/get_user.json
    ${data}         Update Json        ${data}     provider_user_id=${PROVIDER_USER_ID}
    ${json_data}    To Json            ${data}

    &{headers}     Build Authenticated Admin Request Header

    # Perform request
    ${resp}        Post Request    api    ${ADMIN_USER_GET}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    user
    Should be Equal            ${resp.json()['data']['provider_user_id']}    ${PROVIDER_USER_ID}

Update user successfully
    # Initialize
    ${data}         Get Binary File      ${RESOURCE}/update_user.json
    ${username}     Generate Random String
    &{override}     Create Dictionary    provider_user_id=${PROVIDER_USER_ID}    username=${username}
    ${data}         Update Json          ${data}     &{override}
    ${json_data}    To Json              ${data}

    &{headers}     Build Idempotent Authenticated Admin Request Header

    # Perform request
    ${resp}        Post Request    api    ${ADMIN_USER_UPDATE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success         ${resp}
    Assert Object Type              ${resp}    user
    Should be Equal                 ${resp.json()['data']['provider_user_id']}    ${json_data['provider_user_id']}
    Should be Equal                 ${resp.json()['data']['username']}            ${json_data['username']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}            ${json_data['metadata']}
    Should Be Empty                 ${resp.json()['data']['encrypted_metadata']}

List users successfully
    # Build payload
    ${data}       Get Binary File      ${RESOURCE}/get_users.json
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_USER_ALL}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list
    Should Not Be Empty        ${resp.json()['data']['data']}

List user's wallets
    # Build payload
    ${data}       Get Binary File    ${RESOURCE}/get_user_wallets.json
    ${data}       Update Json        ${data}    provider_user_id=${PROVIDER_USER_ID}
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_USER_GET_WALLETS}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list
    Should Not Be Empty        ${resp.json()['data']['data']}

    ${wallet}                         Get From List         ${resp.json()['data']['data']}    0
    ${USER_PRIMARY_WALLET_ADDRESS}    Get Variable Value    ${wallet['address']}
    Set Global Variable               ${USER_PRIMARY_WALLET_ADDRESS}
