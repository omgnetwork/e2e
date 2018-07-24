*** Settings ***
Documentation     Tests related to admin session
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot
Library           ../libraries/Tools.py

*** Variables ***
${JSON_PATH}      ${RESOURCE_PATH}/admin_session

*** Test Cases ***
Logout an admin user successfully
    # Login first to get a token
    ${data}    Get Binary File    ${JSON_PATH}/admin_login.json
    &{override}    Create Dictionary    email=${ADMIN_EMAIL}    password=${ADMIN_PASSWORD}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Admin Request Header
    ${resp}    Post Request    api    ${ADMIN_LOGIN}    data=${data}    headers=${headers}
    ${authentication_token}    Get Variable Value    ${resp.json()['data']['authentication_token']}
    ${user_id}    Get Variable Value    ${resp.json()['data']['user_id']}
    ${admin_user_authentication}    Build Authentication    ${ADMIN_AUTH_SCHEMA}    ${user_id}    ${authentication_token}
    # Build payload
    &{headers}    Build Admin Request Header
    &{headers}    Create Dictionary    Authorization=${admin_user_authentication}    &{headers}
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_LOGOUT}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}

Login an admin user successfully with correct credentials
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/admin_login.json
    &{override}    Create Dictionary    email=${ADMIN_EMAIL}    password=${ADMIN_PASSWORD}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_LOGIN}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    authentication_token
    ${MASTER_ACCOUNT_ID}    Get Variable Value    ${resp.json()['data']['account_id']}
    Set Global Variable    ${MASTER_ACCOUNT_ID}
    ${authentication_token}    Get Variable Value    ${resp.json()['data']['authentication_token']}
    ${user_id}    Get Variable Value    ${resp.json()['data']['user_id']}
    ${ADMIN_USER_AUTHENTICATION}    Build Authentication    ${ADMIN_AUTH_SCHEMA}    ${user_id}    ${authentication_token}
    # Set the variable as global so it can be used in other suites
    Set Global Variable    ${ADMIN_USER_AUTHENTICATION}

Login an admin user fails if required parameters are not provided
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/admin_login.json
    &{override}    Create Dictionary    email=${None}    password=${None}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_LOGIN}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    client:invalid_parameter
    Should be Equal    ${resp.json()['data']['description']}    Invalid parameter provided

Login an admin user fails if wrong credentials are provided
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/admin_login.json
    &{override}    Create Dictionary    email=invalid@email.com    password=invalid_password
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_LOGIN}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should Be Equal    ${resp.json()['data']['code']}    user:invalid_login_credentials
    Should Be Equal    ${resp.json()['data']['description']}    There is no user corresponding to the provided login credentials

Request to reset password successfully with correct credentials
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/reset_password.json
    &{override}    Create Dictionary    email=${ADMIN_EMAIL}    redirect_url=${RESET_PASSWORD_URL}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_RESET_PASSWORD}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}

Request to reset password fails if required parameters are not provided
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/reset_password.json
    &{override}    Create Dictionary    email=${None}    redirect_url=${RESET_PASSWORD_URL}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_RESET_PASSWORD}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Should be Equal    ${resp.json()['data']['code']}    client:invalid_parameter
    Should be Equal    ${resp.json()['data']['description']}    Invalid parameter provided

Request to reset password fails if an invalid email is provided
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/reset_password.json
    &{override}    Create Dictionary    email=invalid@email.com    redirect_url=${RESET_PASSWORD_URL}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_RESET_PASSWORD}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Should Be Equal    ${resp.json()['data']['code']}    user:email_not_found
    Should Be Equal    ${resp.json()['data']['description']}    There is no user corresponding to the provided email

Request to reset password fails if an invalid redirect URL is provided
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/reset_password.json
    &{override}    Create Dictionary    email=${ADMIN_EMAIL}    redirect_url=http://invalid.com
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_RESET_PASSWORD}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Should Be Equal    ${resp.json()['data']['code']}    client:invalid_parameter
    Should Be Equal    ${resp.json()['data']['description']}    The `redirect_url` is not allowed to be used. Got: http://invalid.com
