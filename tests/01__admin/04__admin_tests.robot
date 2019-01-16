*** Settings ***
Documentation     Tests related to admins
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot
Library           ../libraries/Tools.py

*** Variables ***
${JSON_PATH}      ${RESOURCE_PATH}/admin

*** Test Cases ***
List all admins successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_admins.json

    ${filter_1}    Create Dictionary    field=email    comparator=eq    value=${ADMIN_EMAIL}
    ${filter_2}    Create Dictionary    field=email    comparator=eq    value=${ADMIN_1_EMAIL}
    @{match_any}    Create List   ${filter_1}    ${filter_2}

    ${data}    Update Json    ${data}    match_any=@{match_any}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ALL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    ${total_count}    Get Length    ${resp.json()['data']['data']}
    Should Be Equal As Strings    ${total_count}    2
    ${filtered_list}    Filter List    ${resp.json()['data']['data']}    email    ${ADMIN_EMAIL}
    ${filtered_count}    Get Length    ${filtered_list}
    Should Be Equal As Strings    ${filtered_count}    1
    ${admin}    Get From List    ${filtered_list}    0
    ${ADMIN_ID}    Get Variable Value    ${admin['id']}
    Set Global Variable    ${ADMIN_ID}

Get an admin successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_admin.json
    ${data}    Update Json    ${data}    id=${ADMIN_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Should be Equal    ${resp.json()['data']['id']}    ${ADMIN_ID}

Get my user successfully
    # Build payload
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_GET}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    user
    Should be Equal    ${resp.json()['data']['email']}    ${ADMIN_EMAIL}
    ${MY_USER_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Suite Variable    ${MY_USER_ID}

Update my user successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_my_user.json
    ${data}    Update Json    ${data}    email=${ADMIN_EMAIL}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_UPDATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    user
    Should be Equal    ${resp.json()['data']['id']}    ${MY_USER_ID}
    Dictionaries Should be Equal    ${resp.json()['data']['metadata']}    ${json_data['metadata']}

Disable an admin successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/enable_or_disable.json
    ${data}    Update Json    ${data}    id=${ADMIN_1_ID}    enabled=${FALSE}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ENABLE_OR_DISABLED}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    user
    Should be Equal    ${resp.json()['data']['id']}    ${ADMIN_1_ID}
    Should Not Be True    ${resp.json()['data']['enabled']}

Disable an admin fails if id does not exist
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/enable_or_disable.json
    ${data}    Update Json    ${data}    id=${None}    enabled=${None}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ENABLE_OR_DISABLED}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    user:id_not_found
    Should be Equal    ${resp.json()['data']['description']}    There is no user corresponding to the provided id.

Login an admin user fails if the admin is disabled
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/admin_login.json
    &{override}    Create Dictionary    email=${ADMIN_1_EMAIL}    password=${ADMIN_1_PASSWORD}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_LOGIN}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    user:invalid_login_credentials
    Should be Equal    ${resp.json()['data']['description']}    There is no user corresponding to the provided login credentials.

Enable an admin successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/enable_or_disable.json
    ${data}    Update Json    ${data}    id=${ADMIN_1_ID}    enabled=${TRUE}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ENABLE_OR_DISABLED}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    user
    Should be Equal    ${resp.json()['data']['id']}    ${ADMIN_1_ID}
    Should Be True    ${resp.json()['data']['enabled']}

Update my user's password successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_password.json
    ${data}    Update Json    ${data}    old_password=${ADMIN_PASSWORD}    password=${ADMIN_PASSWORD}    password_confirmation=${ADMIN_PASSWORD}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_UPDATE_PASSWORD}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    user
    Should be Equal    ${resp.json()['data']['id']}    ${MY_USER_ID}

Update my user avatar successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/upload_my_avatar.json
    ${data}    To Json    ${data}
    Set To Dictionary    ${data}    id=${MY_USER_ID}
    ${avatar_file}    Get Binary File    ${RESOURCE_PATH}/GO.jpg
    @{image_attributes}    Create List    GO.jpg    ${avatar_file}    image/jpeg
    &{files}    Create Dictionary    avatar=${image_attributes}
    &{headers}    Build Form Data Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_UPDLOAD_AVATAR}    data=${data}    files=${files}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    user
    Should be Equal    ${resp.json()['data']['id']}    ${MY_USER_ID}
    ${avatar_resp}    Get Variable Value    ${resp.json()['data']['avatar']}
    Should Not Be Empty    ${avatar_resp['thumb']}
    Should Not Be Empty    ${avatar_resp['small']}
    Should Not Be Empty    ${avatar_resp['original']}
    Should Not Be Empty    ${avatar_resp['large']}
    ${get_image}    Get Request    api    ${avatar_resp['thumb']}
    Should Be Equal As Strings    ${get_image.status_code}    200

Request to update my user email successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_my_email.json
    ${data}    Update Json    ${data}    redirect_url=${HTTP_BASE_HOST}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_UPDATE_EMAIL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Should be Equal    ${resp.json()['data']['id']}    ${MY_USER_ID}

Request to update my user email fails if the redirect_url is invalid
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_my_email.json
    ${data}    Update Json    ${data}    redirect_url=http://invalid.url
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_UPDATE_EMAIL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Should be Equal    ${resp.json()['data']['code']}    client:invalid_parameter
    Should be Equal    ${resp.json()['data']['description']}    The given `redirect_url` is not allowed. Got: 'http://invalid.url'.

Request to update my user email fails if the email is invalid
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_my_email.json
    ${data}    Update Json    ${data}    email=invalid_email    redirect_url=${HTTP_BASE_HOST}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_UPDATE_EMAIL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Should be Equal    ${resp.json()['data']['code']}    client:invalid_parameter
    Should be Equal    ${resp.json()['data']['description']}    Invalid parameter provided. `email` must be a valid email address format.

List my account successfully
    # Build payload
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_GET_ACCOUNT}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    account

List my accounts successfully
    # Build payload
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ME_GET_ACCOUNTS}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}
