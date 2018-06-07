*** Settings ***
Documentation    This file contains some keywords for request and response assertion

Variables  variables.py

Library  Collections
Library  String

# Library  RequestsLibrary
Library  libraries/SimplePost.py

*** Keywords ***
Create API Session
    Create Session    api    ${HOST}

Assert Response Success
    [Arguments]    ${resp}
    Should be True      ${resp.json()['success']}

Assert Object Type
    [Arguments]    ${resp}    ${object_type}
    Should be Equal    ${resp.json()['data']['object']}    ${object_type}
