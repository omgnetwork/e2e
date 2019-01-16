*** Settings ***
Documentation     Tests related to the configuration settings
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot

*** Variables ***
${JSON_PATH}      ${RESOURCE_PATH}/configuration

*** Test Cases ***
Update configuration successfully and set the file storage adapter to gcs
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_configuration.json
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_UPDATE_CONFIGURATION}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    map
    Should Be Equal    ${resp.json()['data']['data']['file_storage_adapter']['value']}    gcs

Get configuration successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_configuration.json
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_GET_CONFIGURATION}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Length Should Be    ${resp.json()['data']['data']}    1
    ${setting}    Get From List    ${resp.json()['data']['data']}    0
    ${file_storage_adapter}    Get Variable Value    ${setting['value']}
    Should Be Equal    ${file_storage_adapter}    gcs

Update configuration successfully and set the file storage adapter to local
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_configuration.json
    ${data}    Update Json    ${data}    file_storage_adapter=local
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_UPDATE_CONFIGURATION}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    map
    Should Be Equal    ${resp.json()['data']['data']['file_storage_adapter']['value']}    local
