*** Settings ***
Documentation    Tests related to settings

Resource    admin_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Get settings successfully
    # Build payload
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_GET_SETTINGS}     headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    setting
    Should Not Be Empty        ${resp.json()['data']['tokens']}
