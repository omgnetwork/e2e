*** Settings ***
Documentation    Tests related to users

Resource    admin_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Get my user successfully
    # Build payload
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_USER_ME_GET}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    user
    Should be Equal            ${resp.json()['data']['email']}    ${ADMIN_EMAIL}

    ${MY_USER_ID}         Get Variable Value    ${resp.json()['data']['id']}
    Set Suite Variable    ${MY_USER_ID}

Update my user successfully
    # Build payload
    ${data}         Get Binary File    ${RESOURCE}/me_update.json
    ${json_data}    To Json            ${data}
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_USER_ME_UPDATE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    user
    Should be Equal            ${resp.json()['data']['id']}    ${MY_USER_ID}
    Dictionaries Should be Equal    ${resp.json()['data']['metadata']}    ${json_data['metadata']}

List my account successfully
    # Build payload
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_USER_ME_GET_ACCOUNT}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    account

List my accounts successfully
    # Build payload
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_USER_ME_GET_ACCOUNTS}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list
    Should Not Be Empty        ${resp.json()['data']['data']}

Get a user successfully
    # Build payload
    ${data}       Get Binary File    ${RESOURCE}/get_user.json
    ${data}       Update Json        ${data}    id=${MY_USER_ID}
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_USER_GET}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    user
    Should be Equal            ${resp.json()['data']['id']}       ${MY_USER_ID}
    Should be Equal            ${resp.json()['data']['email']}    ${ADMIN_EMAIL}

List users successfully
    # Build payload
    ${data}       Get Binary File      ${RESOURCE}/list_users.json
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_USER_ALL}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list
    Should Not Be Empty        ${resp.json()['data']['data']}

List user's wallets
    #TODO when we have wallets
