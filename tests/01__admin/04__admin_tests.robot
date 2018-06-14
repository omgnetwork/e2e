*** Settings ***
Documentation    Tests related to admins

Resource    admin_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
List all admins successfully
    # Add admin to account
    ${data}         Get Binary File      ${RESOURCE}/assign_user_to_account.json
    &{override}     Create Dictionary    email=${ADMIN_1_EMAIL}    account_id=${ACCOUNT_ID}
    ${data}         Update Json          ${data}                  &{override}
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}        Post Request    api    ${ADMIN_ACCOUNT_ASSIGN_USER}    data=${data}    headers=${headers}

    # Build payload
    ${data}         Get Binary File      ${RESOURCE}/get_admins.json
    ${data}         Update Json          ${data}    search_term=${ADMIN_1_EMAIL}
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}        Post Request    api    ${ADMIN_ADMIN_ALL}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list

    ${admin}                   Get From List        ${resp.json()['data']['data']}    0
    Should be Equal            ${admin['email']}    ${ADMIN_1_EMAIL}

Get an admin successfully
    # Build payload
    ${data}         Get Binary File      ${RESOURCE}/get_admin.json
    ${data}         Update Json          ${data}    id=${ADMIN_1_ID}
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}        Post Request    api    ${ADMIN_ADMIN_GET}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}

Get my user successfully
    # Build payload
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_GET}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    user
    Should be Equal            ${resp.json()['data']['email']}    ${ADMIN_EMAIL}

    ${MY_USER_ID}         Get Variable Value    ${resp.json()['data']['id']}
    Set Global Variabl    ${MY_USER_ID}

Update my user successfully
    # Build payload
    ${data}         Get Binary File    ${RESOURCE}/me_update.json
    ${data}         Update Json        ${data}    email=${ADMIN_EMAIL}
    ${json_data}    To Json            ${data}
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_UPDATE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    user
    Should be Equal            ${resp.json()['data']['id']}    ${MY_USER_ID}
    Dictionaries Should be Equal    ${resp.json()['data']['metadata']}    ${json_data['metadata']}

List my account successfully
    # Build payload
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_GET_ACCOUNT}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    account

List my accounts successfully
    # Build payload
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_GET_ACCOUNTS}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list
    Should Not Be Empty        ${resp.json()['data']['data']}
