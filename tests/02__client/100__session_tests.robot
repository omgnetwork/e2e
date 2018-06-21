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
