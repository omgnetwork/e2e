*** Settings ***
Documentation     Tests related to accounts
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot
Library           ../libraries/Tools.py

*** Variables ***
${JSON_PATH}      ${RESOURCE_PATH}/account

*** Test Cases ***
Create an account successfully with correct parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/create_account.json
    ${acc_name}    Generate Random String
    ${data}    Update Json    ${data}    name=${acc_name}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    account
    Should be Equal    ${resp.json()['data']['name']}    ${json_data['name']}
    Should be Equal    ${resp.json()['data']['description']}    ${json_data['description']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}    ${json_data['metadata']}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}    ${json_data['encrypted_metadata']}
    ${ACCOUNT_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Global Variable    ${ACCOUNT_ID}

Create an account fails if required parameters are not provided
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/create_account.json
    ${acc_name}    Generate Random String
    ${data}    Update Json    ${data}    name=${None}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    client:invalid_parameter
    Should be Equal    ${resp.json()['data']['description']}    Invalid parameter provided. `name` can't be blank.

Update an account successfully with the correct parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_account.json
    ${acc_name}    Generate Random String
    &{updated_acc}    Create Dictionary    id=${ACCOUNT_ID}    name=${acc_name}
    ${data}    Update Json    ${data}    &{updated_acc}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_UPDATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    account
    Should be Equal    ${resp.json()['data']['id']}    ${ACCOUNT_ID}
    Should be Equal    ${resp.json()['data']['name']}    ${json_data['name']}
    Should be Equal    ${resp.json()['data']['description']}    ${json_data['description']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}    ${json_data['metadata']}
    Should Be Empty    ${resp.json()['data']['encrypted_metadata']}

Update an account fails if the account id is invalid
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_account.json
    ${acc_name}    Generate Random String
    &{updated_acc}    Create Dictionary    id=${None}    name=${acc_name}
    ${data}    Update Json    ${data}    &{updated_acc}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_UPDATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    unauthorized
    Should be Equal    ${resp.json()['data']['description']}    You are not allowed to perform the requested operation.

Update an account fails if required parameters are not provided
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_account.json
    ${acc_name}    Generate Random String
    &{updated_acc}    Create Dictionary    id=${ACCOUNT_ID}    name=${None}
    ${data}    Update Json    ${data}    &{updated_acc}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_UPDATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    client:invalid_parameter
    Should be Equal    ${resp.json()['data']['description']}    Invalid parameter provided. `name` can't be blank.

Update an account avatar successfully with correct parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/upload_account_avatar.json
    ${data}    To Json    ${data}
    Set To Dictionary    ${data}    id=${ACCOUNT_ID}
    ${avatar_file}    Get Binary File    ${RESOURCE_PATH}/GO.jpg
    @{image_attributes}    Create List    GO.jpg    ${avatar_file}    image/jpeg
    &{files}    Create Dictionary    avatar=${image_attributes}
    &{headers}    Build Form Data Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_UPLOAD_AVATAR}    data=${data}    files=${files}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    account
    Should be Equal    ${resp.json()['data']['id']}    ${ACCOUNT_ID}
    ${avatar_resp}    Get Variable Value    ${resp.json()['data']['avatar']}
    Should Not Be Empty    ${avatar_resp['thumb']}
    Should Not Be Empty    ${avatar_resp['small']}
    Should Not Be Empty    ${avatar_resp['original']}
    Should Not Be Empty    ${avatar_resp['large']}
    ${get_image}    Get Request    api    ${avatar_resp['thumb']}
    Should Be Equal As Strings    ${get_image.status_code}    200

Update an account avatar fails if the account id is invalid
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/upload_account_avatar.json
    ${data}    To Json    ${data}
    Set To Dictionary    ${data}    id=invalid_id
    ${avatar_file}    Get Binary File    ${RESOURCE_PATH}/GO.jpg
    @{image_attributes}    Create List    GO.jpg    ${avatar_file}    image/jpeg
    &{files}    Create Dictionary    avatar=${image_attributes}
    &{headers}    Build Form Data Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_UPLOAD_AVATAR}    data=${data}    files=${files}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    unauthorized
    Should be Equal    ${resp.json()['data']['description']}    You are not allowed to perform the requested operation.

Update an account avatar fails if the avatar is not a valid image
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/upload_account_avatar.json
    ${data}    To Json    ${data}
    Set To Dictionary    ${data}    id=${ACCOUNT_ID}
    ${wrong_file}    Get Binary File    ${JSON_PATH}/upload_account_avatar.json
    &{files}    Create Dictionary    avatar=${wrong_file}
    &{headers}    Build Form Data Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_UPLOAD_AVATAR}    data=${data}    files=${files}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    client:invalid_parameter
    Should be Equal    ${resp.json()['data']['description']}    Invalid parameter provided. `avatar` is invalid.

Assign a user to an account successfully with the correct parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/assign_user_to_account.json
    &{override}    Create Dictionary    email=${ADMIN_1_EMAIL}    account_id=${ACCOUNT_ID}    redirect_url=${HTTP_BASE_HOST}/redirect_path?email={email}&token={token}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_ASSIGN_USER}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}

Assign a user to an account fails if email is invalid
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/assign_user_to_account.json
    &{override}    Create Dictionary    email=invalid_email    account_id=${ACCOUNT_ID}    redirect_url=${HTTP_BASE_HOST}/redirect_path?email={email}&token={token}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_ASSIGN_USER}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    user:invalid_email
    Should be Equal    ${resp.json()['data']['description']}    The format of the provided email is invalid.

Assign a user to an account fails if account_id is invalid
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/assign_user_to_account.json
    &{override}    Create Dictionary    email=${ADMIN_1_EMAIL}    account_id=invalid_id
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_ASSIGN_USER}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    unauthorized
    Should be Equal    ${resp.json()['data']['description']}    You are not allowed to perform the requested operation.

Assign a user to an account fails if required parameters are not provided
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/assign_user_to_account.json
    &{override}    Create Dictionary    email=${None}    account_id=${ACCOUNT_ID}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_ASSIGN_USER}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    user:invalid_email
    Should be Equal    ${resp.json()['data']['description']}    The format of the provided email is invalid.

Get admins from an account successfully with the correct parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_members_from_account.json
    ${data}    Update Json    ${data}    id=${ACCOUNT_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET_MEMBERS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    ${filtered_list}    Filter List    ${resp.json()['data']['data']}    email    ${ADMIN_1_EMAIL}
    ${count}    Get Length    ${filtered_list}
    Should Be Equal As Strings    ${count}    1
    ${admin1}    Get From List    ${filtered_list}    0
    ${ADMIN_1_ID}    Get Variable Value    ${admin1['id']}
    Set Global Variable    ${ADMIN_1_ID}

Get admins from an account fails if the account id is invalid
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_members_from_account.json
    ${data}    Update Json    ${data}    id=invalid_id
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET_MEMBERS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    unauthorized
    Should be Equal    ${resp.json()['data']['description']}    You are not allowed to perform the requested operation.

Unassign a user from an account successfully with the correct parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/unassign_user_from_account.json
    &{override}    Create Dictionary    user_id=${ADMIN_1_ID}    account_id=${ACCOUNT_ID}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_UNASSIGN_USER}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    # Re-assign for future tests
    ${data}    Get Binary File    ${JSON_PATH}/assign_user_to_account.json
    &{override}    Create Dictionary    email=${ADMIN_1_EMAIL}    account_id=${ACCOUNT_ID}    redirect_url=${HTTP_BASE_HOST}/redirect_path?email={email}&token={token}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_ASSIGN_USER}    data=${data}    headers=${headers}
    Assert Response Success    ${resp}

Unassign a user from an account fails if the account id is invalid
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/unassign_user_from_account.json
    &{override}    Create Dictionary    user_id=${ADMIN_1_ID}    account_id=invalid_id
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_UNASSIGN_USER}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    unauthorized
    Should be Equal    ${resp.json()['data']['description']}    You are not allowed to perform the requested operation.

Unassign a user from an account fails if the user id is invalid
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/unassign_user_from_account.json
    &{override}    Create Dictionary    user_id=invalid_id    account_id=${ACCOUNT_ID}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_UNASSIGN_USER}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    user:id_not_found
    Should be Equal    ${resp.json()['data']['description']}    There is no user corresponding to the provided id.

List all wallets from an account successfully with the corect parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_wallets_from_account.json
    ${data}    Update Json    ${data}    id=${MASTER_ACCOUNT_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET_WALLETS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}

Get the primary wallet from an account successfully with the corect parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_wallets_from_account.json
    &{match_all_account_id}    Create Dictionary    field=account.id    value=${MASTER_ACCOUNT_ID}    comparator=eq
    &{match_all_identifier}    Create Dictionary    field=identifier    value=primary    comparator=eq
    ${match_all_list}    Create List    ${match_all_account_id}    ${match_all_identifier}
    &{override}    Create Dictionary    match_all=${match_all_list}    id=${MASTER_ACCOUNT_ID}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET_WALLETS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Length Should Be    ${resp.json()['data']['data']}    1
    ${wallet}    Get From List    ${resp.json()['data']['data']}    0
    ${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}    Get Variable Value    ${wallet['address']}
    Set Global Variable    ${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}

List all wallets from an account fails if the account id is invalid
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_wallets_from_account.json
    ${data}    Update Json    ${data}    id=invalid_id
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET_WALLETS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    unauthorized
    Should be Equal    ${resp.json()['data']['description']}    You are not allowed to perform the requested operation.

Get an account successfully with the correct parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_account.json
    ${data}    Update Json    ${data}    id=${ACCOUNT_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}

Get an account fails if the account id is invalid
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_account.json
    ${data}    Update Json    ${data}    id=invalid_id
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    unauthorized
    Should be Equal    ${resp.json()['data']['description']}    You are not allowed to perform the requested operation.

Get descendants of an account successfully with the correct parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_descendants.json
    ${data}    Update Json    ${data}    id=${ACCOUNT_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET_DESCENDANTS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}

Get transactions of an account successfully with the correct parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_transactions.json
    ${data}    Update Json    ${data}    id=${ACCOUNT_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET_TRANSACTIONS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list

Get transaction requests of an account successfully with the correct parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_transaction_requests.json
    ${data}    Update Json    ${data}    id=${ACCOUNT_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_GET_REQUESTS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list

List all accounts successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_accounts.json
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_ACCOUNT_ALL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list

Switch token to account successfully with the correct parameters
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/switch_account.json
    ${data}    Update Json    ${data}    account_id=${ACCOUNT_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_SWITCH_ACCOUNT}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    authentication_token
    Should be Equal    ${resp.json()['data']['account_id']}    ${ACCOUNT_ID}

Switch token to account fails if the account id is invalid
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/switch_account.json
    ${data}    Update Json    ${data}    account_id=invalid_id
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_SWITCH_ACCOUNT}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Failure    ${resp}
    Assert Object Type    ${resp}    error
    Should be Equal    ${resp.json()['data']['code']}    unauthorized
    Should be Equal    ${resp.json()['data']['description']}    You are not allowed to perform the requested operation.
