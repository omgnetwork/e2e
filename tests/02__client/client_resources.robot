*** Settings ***
Documentation    This file contains all ressources needed for client type API calls

Library  Collections

Variables  ../variables.py

Resource    ../resouces.robot

*** Variables ***
${RESOURCE_PATH}    ${CURDIR}/resources

*** Keywords ***
Create Client API Session
    Create Session    api    ${CLIENT_HOST}

Build Request Header
    &{client_headers}    Create Dictionary    Content-Type=${CONTENT_TYPE_HEADER}
    ...                                       Accept=${ACCEPT_HEADER}

    [Return]    &{client_headers}

Build Authenticated Request Header
    &{client_headers}    Create Dictionary    Content-Type=${CONTENT_TYPE_HEADER}
    ...                                       Authorization=${CLIENT_AUTHENTICATION}
    ...                                       Accept=${ACCEPT_HEADER}

    [Return]    &{client_headers}

Build Secondary Authenticated Request Header
    &{client_headers}    Create Dictionary    Content-Type=${CONTENT_TYPE_HEADER}
    ...                                       Authorization=${CLIENT_1_AUTHENTICATION}
    ...                                       Accept=${ACCEPT_HEADER}

    [Return]    &{client_headers}
