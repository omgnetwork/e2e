*** Settings ***
Documentation    Tests related to session

Resource    admin_resources.robot

Library    ../libraries/Tools.py

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Login an admin user successfully
    # Build payload
    ${data}         Get Binary File    ${RESOURCE}/login.json
    ${json_data}    To Json            ${data}
    &{headers}      Build Admin Request Header

    # Perform request
    ${resp}        Post Request    api    ${ADMIN_LOGIN}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    authentication_token
    ${authentication_token}    Get Variable Value    ${resp.json()['data']['authentication_token']}
    ${user_id}                 Get Variable Value    ${resp.json()['data']['user_id']}

    ${ADMIN_USER_AUTHENTICATION}    Build Authentication    ${ADMIN_AUTH_SCHEMA}
    ...                                                     ${user_id}
    ...                                                     ${authentication_token}

    # Set the variable as global so it can be used in other suites
    Set Global Variable    ${ADMIN_USER_AUTHENTICATION}
