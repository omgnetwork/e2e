*** Settings ***
Documentation     Tests related to sessions
Suite Setup       Create Client API Session
Suite Teardown    Delete All Sessions
Resource          client_resources.robot

*** Test Cases ***
Logout successfully
    # Build payload
    &{headers}    Build Authenticated Request Header
    # Perform request
    ${resp}    Post Request    api    ${CLIENT_LOGOUT}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}

Sign up successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE_PATH}/sign_up.json
    ${random}    Generate Random String
    ${email}    Catenate    SEPARATOR=    ${random}    @email.com
    ${password}    Generate Random String
    &{override}    Create Dictionary    email=${email}    password=${password}    password_confirmation=${password}    verification_url=${HTTP_BASE_HOST}/verify_email?email={email}&amp;token={token}    success_url=${HTTP_BASE_HOST}/verify_email/success
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Request Header
    # Perform request
    ${resp}    Post Request    api    ${CLIENT_SIGNUP}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}

Log in successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE_PATH}/log_in.json
    &{override}    Create Dictionary    email=${USER_EMAIL}    password=${USER_PASSWORD}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Request Header
    # Perform request
    ${resp}    Post Request    api    ${CLIENT_LOGIN}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    authentication_token
    Should be Equal    ${resp.json()['data']['user']['email']}    ${USER_EMAIL}
