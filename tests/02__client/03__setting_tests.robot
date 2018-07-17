*** Settings ***
Documentation     Tests related to settings
Suite Setup       Create Client API Session
Suite Teardown    Delete All Sessions
Resource          client_resources.robot

*** Test Cases ***
Get eWallet settings successfully
    # Build payload
    &{headers}    Build Authenticated Request Header
    # Perform request
    ${resp}    Post Request    api    ${CLIENT_GET_SETTINGS}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    setting
    Should Not Be Empty    ${resp.json()['data']['tokens']}
