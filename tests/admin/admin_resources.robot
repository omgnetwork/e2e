*** Settings ***
Documentation    This file contains all ressources needed for admin type API calls

Library  Collections

Variables  ../variables.py

Resource    ../resouces.robot

*** Keywords ***
Create API Session
    Create Session    api    ${ADMIN_HOST}

Build Admin Request Header
    [Arguments]    &{headers}
    &{admin_headers}    Create Dictionary     Content-Type=${CONTENT_TYPE_HEADER}
    ...                                       Accept=${ACCEPT_HEADER}
    &{combined_headers}    Create Dictionary    &{admin_headers}    &{headers}
    [Return]    &{combined_headers}

Build Admin User Request Header
    [Arguments]    &{headers}
    &{admin_headers}    Create Dictionary    Content-Type=${CONTENT_TYPE_HEADER}
    ...                                      Authorization=${SERVER_AUTH}
    ...                                      Accept=${ACCEPT_HEADER}
    &{combined_headers}    Create Dictionary    &{admin_headers}    &{headers}
    [Return]    &{combined_headers}
