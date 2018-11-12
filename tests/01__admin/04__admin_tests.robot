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
    ${data}    Update Json    ${data}    search_term=${ADMIN_EMAIL}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ADMIN_ALL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    ${filtered_list}    Filter List    ${resp.json()['data']['data']}    email    ${ADMIN_EMAIL}
    ${count}    Get Length    ${filtered_list}
    Should Be Equal As Strings    ${count}    1
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
