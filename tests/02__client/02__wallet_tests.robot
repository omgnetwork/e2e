*** Settings ***
Documentation    Tests related to wallets

Resource    client_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Get my wallets successfully
    # Build payload
    &{headers}    Build Authenticated Request Header

    # Perform request
    ${resp}    Post Request    api    ${CLIENT_GET_WALLETS}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list
    Should Not Be Empty        ${resp.json()['data']['data']}
