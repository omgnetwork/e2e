*** Settings ***
Documentation     Tests related to admin session
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot
Library           ../libraries/Tools.py

*** Test Cases ***
Logout user successfully
    # Login first to get a token
    ${data}    Get Binary File    ${RESOURCE}/user_login.json
    ${data}    Update Json    ${data}    provider_user_id=${PROVIDER_USER_ID}
    &{headers}    Build Authenticated Admin Request Header
    ${resp}    Post Request    api    ${ADMIN_USER_LOGIN}    data=${data}    headers=${headers}
    ${authentication_token}    Get Variable Value    ${resp.json()['data']['authentication_token']}
    #Build payload
    ${data}    Get Binary File    ${RESOURCE}/user_logout.json
    ${data}    Update Json    ${data}    auth_token=${authentication_token}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_USER_LOGOUT}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}

Login a user successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/user_login.json
    ${data}    Update Json    ${data}    provider_user_id=${PROVIDER_USER_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_USER_LOGIN}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    authentication_token
    ${authentication_token}    Get Variable Value    ${resp.json()['data']['authentication_token']}
    ${CLIENT_AUTHENTICATION}    Build Authentication    ${CLIENT_AUTH_SCHEMA}    ${API_KEY}    ${authentication_token}
    # Set the variable as global so it can be used in other suites
    Set Global Variable    ${CLIENT_AUTHENTICATION}
    # login an other user for client tests
    ${data}    Update Json    ${data}    provider_user_id=${PROVIDER_USER_1_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_USER_LOGIN}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    ${authentication_token}    Get Variable Value    ${resp.json()['data']['authentication_token']}
    ${CLIENT_1_AUTHENTICATION}    Build Authentication    ${CLIENT_AUTH_SCHEMA}    ${API_KEY}    ${authentication_token}
    Set Global Variable    ${CLIENT_1_AUTHENTICATION}
