*** Settings ***
Documentation    Tests related to users

Resource    client_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Get my user successfully
    # Build payload
    &{headers}    Build Authenticated Request Header

    # Perform request
    ${resp}    Post Request    api    ${CLIENT_GET}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    user
    Should be Equal            ${resp.json()['data']['provider_user_id']}    ${PROVIDER_USER_ID}
