*** Settings ***
Documentation    Tests related to api and secret keys

Resource    admin_resources.robot

Library    ../libraries/Tools.py

Suite Setup     Create Admin API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Create an access key successfully
    # Build payload
    &{headers}        Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_KEY_ACCESS_CREATE}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    key
    ${access_key}              Get Variable Value    ${resp.json()['data']['access_key']}
    ${secret_key}              Get Variable Value    ${resp.json()['data']['secret_key']}

    ${SERVER_AUTHENTICATION}    Build Authentication    ${PROVIDER_AUTH_SCHEMA}
    ...                                                 ${access_key}
    ...                                                 ${secret_key}

    # Set the variable as global so it can be used in other suites
    Set Global Variable    ${SERVER_AUTHENTICATION}

List access keys successfully
    # Build payload
    ${data}       Get Binary File      ${RESOURCE}/get_access_keys.json
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_KEY_ACCESS_ALL}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list
    Should Not Be Empty        ${resp.json()['data']['data']}

Delete an access key successfully
    # Create an access key to delete
    &{headers}          Build Authenticated Admin Request Header
    ${resp}             Post Request    api    ${ADMIN_KEY_ACCESS_CREATE}    headers=${headers}
    ${access_key_id}    Get Variable Value    ${resp.json()['data']['id']}

    # Build payload
    ${data}        Get Binary File      ${RESOURCE}/delete_access_key.json
    ${data}        Update Json          ${data}         id=${access_key_id}
    &{headers}     Build Authenticated Admin Request Header

    # Perform request
    ${resp}        Post Request    api    ${ADMIN_KEY_ACCESS_DELETE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}

Create an api key successfully
    # Build payload
    ${data}       Get Binary File      ${RESOURCE}/create_api_key.json
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_KEY_API_CREATE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    api_key
    ${API_KEY}                 Get Variable Value    ${resp.json()['data']['key']}
    Set Global Variable        ${API_KEY}

List api keys successfully
    # Build payload
    ${data}       Get Binary File      ${RESOURCE}/get_api_keys.json
    &{headers}    Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_KEY_API_ALL}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list
    Should Not Be Empty        ${resp.json()['data']['data']}

Delete an api key successfully
    # Create an api key to delete
    &{headers}       Build Authenticated Admin Request Header
    ${data}          Get Binary File       ${RESOURCE}/create_api_key.json
    ${resp}          Post Request          api    ${ADMIN_KEY_API_CREATE}    data=${data}    headers=${headers}
    ${api_key_id}    Get Variable Value    ${resp.json()['data']['id']}

    # Build payload
    ${data}        Get Binary File      ${RESOURCE}/delete_api_key.json
    ${data}        Update Json          ${data}         id=${api_key_id}
    &{headers}     Build Authenticated Admin Request Header

    # Perform request
    ${resp}        Post Request    api    ${ADMIN_KEY_API_DELETE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
