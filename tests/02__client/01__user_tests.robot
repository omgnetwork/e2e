*** Settings ***
Documentation     Tests related to users
Suite Setup       Create Client API Session
Suite Teardown    Delete All Sessions
Resource          client_resources.robot

*** Test Cases ***
Get my user successfully
    # Build payload
    &{headers}    Build Authenticated Request Header
    # Perform request
    ${resp}    Post Request    api    ${CLIENT_GET}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    user
    Should be Equal    ${resp.json()['data']['provider_user_id']}    ${PROVIDER_USER_ID}
