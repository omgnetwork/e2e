*** Settings ***

Resource    server_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Login a user successfully
    # Build payload
    &{data}        Create Dictionary    provider_user_id=${PROVIDER_USER_ID}
    &{headers}     Build Server Request Header

    # Perform request
    ${resp}        Post Request    api    ${LOGIN}    json=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    authentication_token
    ${authentication_token}    Get Variable Value    ${resp.json()['data']['authentication_token']}
    # TODO:
    # Create a global variable with this ${authentication_token} base64 encoded
    # along with an API key in order to do client tests
