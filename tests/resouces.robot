*** Settings ***
Documentation    This file contains some keywords for request and response assertion

Variables    variables.py

Library    Collections
Library    String
Library    OperatingSystem

Library    RequestsLibrary

*** Keywords ***
Assert Response Success
    [Arguments]    ${resp}

    Should be True      ${resp.json()['success']}

Assert Object Type
    [Arguments]    ${resp}    ${object_type}

    Should be Equal    ${resp.json()['data']['object']}    ${object_type}

Update Json
    [Arguments]    ${json}    &{updates}

    ${json_dictionary}    To Json               ${json}
    Set To Dictionary     ${json_dictionary}    &{updates}
    ${json_string}=       evaluate              json.dumps(${json_dictionary})    json

    [Return]    ${json_string}
