*** Settings ***
Documentation    This file contains all ressources needed for admin type API calls

Library  Collections

Variables  ../variables.py

Resource    ../resouces.robot

*** Variables ***
${RESOURCE_PATH}    ${CURDIR}/resources

*** Keywords ***
Create Admin API Session
    Create Session    api    ${ADMIN_HOST}    timeout=15

Build Admin Request Header
    &{admin_headers}    Create Dictionary     Content-Type=${CONTENT_TYPE_HEADER}
    ...                                       Accept=${ACCEPT_HEADER}

    [Return]    &{admin_headers}

Build Authenticated Admin Request Header
    &{admin_headers}    Create Dictionary    Content-Type=${CONTENT_TYPE_HEADER}
    ...                                      Authorization=${ADMIN_USER_AUTHENTICATION}
    ...                                      Accept=${ACCEPT_HEADER}

    [Return]    &{admin_headers}

Build Form Data Authenticated Admin Request Header
    &{admin_headers}    Create Dictionary    Authorization=${ADMIN_USER_AUTHENTICATION}
    ...                                      Accept=${ACCEPT_HEADER}

    [Return]    &{admin_headers}
