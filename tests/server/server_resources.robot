*** Settings ***
Documentation    This file contains all ressources needed for server type API calls

Library  Collections

Variables  ../variables.py

Resource    ../resouces.robot

*** Variables ***
${RESOURCE}    resources

*** Keywords ***
Create API Session
    Create Session    api    ${HOST}

Build Server Request Header
    &{headers}    Create Dictionary    Content-Type=${CONTENT_TYPE_HEADER}
    ...                                Authorization=${SERVER_AUTH}
    ...                                Accept=${ACCEPT_HEADER}
    [Return]    &{headers}

Build Idempotent Server Request Header
    ${idempotency_token}     Generate Random String
    &{headers}    Create Dictionary    Content-Type=${CONTENT_TYPE_HEADER}
    ...                                Authorization=${SERVER_AUTH}
    ...                                Accept=${ACCEPT_HEADER}
    ...                                Idempotency-Token=${idempotency_token}
    [Return]    &{headers}
