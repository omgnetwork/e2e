*** Settings ***
Documentation    Server authentication testing
...              Tests related to user ressource

Resource    server_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Create user successfully
    # Initialize
    ${provider_user_id}      Generate Random String
    ${username}              Generate Random String
    &{metadata}              Create Dictionary    a_key=a_value
    &{encrypted_metadata}    Create Dictionary    a_key=a_value

    ${idempotency_token}     Generate Random String

    # Set the provider_user_id and metadata variables as a suite variable
    # so it can be accessed in other tests of this suite.
    Set Suite Variable    ${provider_user_id}
    Set Suite Variable    &{metadata}

    # Build payload
    &{data}        Create Dictionary    provider_user_id=${provider_user_id}
    ...                                 username=${username}
    ...                                 metadata=&{metadata}
    ...                                 encrypted_metadata=&{encrypted_metadata}
    &{headers}     Build Server Request Header    Idempotency-Token=${idempotency_token}

    # Perform request
    ${resp}        Post Request    api    ${USER_CREATE}    json=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    user
    Should be Equal            ${resp.json()['data']['provider_user_id']}    ${provider_user_id}
    Should be Equal            ${resp.json()['data']['username']}            ${username}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}              ${metadata}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}    ${encrypted_metadata}

Get user successfully
    # Build payload
    &{data}        Create Dictionary    provider_user_id=${provider_user_id}
    &{headers}     Build Server Request Header

    # Perform request
    ${resp}        Post Request    api    ${USER_GET}    json=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    user
    Should be Equal            ${resp.json()['data']['provider_user_id']}    ${provider_user_id}

Update user successfully
    # Initialize
    ${username}              Generate Random String
    ${idempotency_token}     Generate Random String
    &{encrypted_metadata}    Create Dictionary

    # Build payload
    &{data}        Create Dictionary    provider_user_id=${provider_user_id}
    ...                                 username=${username}
    ...                                 encrypted_metadata=&{encrypted_metadata}
    &{headers}     Build Server Request Header    Idempotency-Token=${idempotency_token}

    # Perform request
    ${resp}        Post Request    api    ${USER_UPDATE}    json=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    user
    Should be Equal            ${resp.json()['data']['provider_user_id']}    ${provider_user_id}
    Should be Equal            ${resp.json()['data']['username']}            ${username}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}              ${metadata}
    Should Be Empty            ${resp.json()['data']['encrypted_metadata']}
