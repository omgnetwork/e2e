*** Settings ***
Documentation    This file contains all ressources needed for client type API calls

Library  Collections

Variables  ../variables.py

Resource    ../resouces.robot

*** Variables ***
${RESOURCE}    ${CURDIR}/resources

*** Keywords ***
Create API Session
    Create Session    api    ${CLIENT_HOST}

Build Authenticated Request Header
    [Arguments]    &{headers}

    &{admin_headers}    Create Dictionary    Content-Type=${CONTENT_TYPE_HEADER}
    ...                                      Authorization=${CLIENT_AUTHENTICATION}
    ...                                      Accept=${ACCEPT_HEADER}
    &{combined_headers}    Create Dictionary    &{admin_headers}    &{headers}

    [Return]    &{combined_headers}

Build Idempotent Authenticated Request Header
    [Arguments]    &{headers}
    ${idempotency_token}     Generate Random String
    &{admin_headers}    Create Dictionary    Content-Type=${CONTENT_TYPE_HEADER}
    ...                                      Authorization=${CLIENT_AUTHENTICATION}
    ...                                      Accept=${ACCEPT_HEADER}
    ...                                      Idempotency-Token=${idempotency_token}
    &{combined_headers}    Create Dictionary    &{admin_headers}    &{headers}

    [Return]    &{combined_headers}
