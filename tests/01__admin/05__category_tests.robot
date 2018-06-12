*** Settings ***
Documentation    Tests related to categories

Resource    admin_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Create category successfully
    # Build payload
    ${data}           Get Binary File      ${RESOURCE}/create_category.json
    ${name}           Generate Random String
    @{account_ids}    Create List          ${ACCOUNT_ID}
    &{override}       Create Dictionary    name=${name}    account_ids=${account_ids}
    ${data}           Update Json          ${data}         &{override}
    ${json_data}      To Json              ${data}
    &{headers}        Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_CATEGORY_CREATE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    category
    Should be Equal            ${resp.json()['data']['name']}           ${json_data['name']}
    Should be Equal            ${resp.json()['data']['description']}    ${json_data['description']}

    ${CATEGORY_ID}             Get Variable Value    ${resp.json()['data']['id']}
    Set Suite Variable         ${CATEGORY_ID}


    Lists Should Be Equal      ${resp.json()['data']['account_ids']}    ${account_ids}

Get a category successfully
    # Build payload
    ${data}       Get Binary File      ${RESOURCE}/get_category.json
    ${data}       Update Json          ${data}    id=${CATEGORY_ID}
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_CATEGORY_GET}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    category
    Should be Equal            ${resp.json()['data']['id']}           ${CATEGORY_ID}

Update a category successfully
    # Build payload
    ${data}        Get Binary File      ${RESOURCE}/update_category.json
    ${name}        Generate Random String
    &{override}    Create Dictionary    name=${name}    id=${CATEGORY_ID}
    ${data}        Update Json          ${data}         &{override}
    &{headers}     Build Authenticated Admin Request Header

    # Perform request
    ${resp}        Post Request    api    ${ADMIN_CATEGORY_UPDATE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    category
    Should be Equal            ${resp.json()['data']['id']}      ${CATEGORY_ID}
    Should Be Equal            ${resp.json()['data']['name']}    ${name}

List all categories successfully
    # Build payload
    ${data}       Get Binary File      ${RESOURCE}/list_categories.json
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_CATEGORY_ALL}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list
    Should Not Be Empty        ${resp.json()['data']['data']}

Delete a category successfully
    # Build payload
    ${data}        Get Binary File      ${RESOURCE}/delete_category.json
    ${data}        Update Json          ${data}         id=${CATEGORY_ID}
    &{headers}     Build Authenticated Admin Request Header

    # Perform request
    ${resp}        Post Request    api    ${ADMIN_CATEGORY_DELETE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    category
    Should be Equal            ${resp.json()['data']['id']}      ${CATEGORY_ID}
