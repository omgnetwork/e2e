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
