*** Settings ***

Resource    server_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Get the user's wallets successfully
    # Build payload
    &{data}        Create Dictionary    provider_user_id=${PROVIDER_USER_ID}
    &{headers}     Build Server Request Header

    # Perform request
    ${resp}        Post Request    api    ${USER_LIST_WALLETS}    json=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list
