*** Settings ***
Documentation    This file contains all ressources needed for server type API calls

Library  Collections

Variables  ../variables.py

*** Keywords ***
Build Server Request Header
    [Arguments]    &{headers}
    &{server_headers}    Create Dictionary    Content-Type=${CONTENT_TYPE_HEADER}
    ...                                       Authorization=${SERVER_AUTH}
    ...                                       Accept=${ACCEPT_HEADER}
    &{combined_headers}    Create Dictionary    &{server_headers}    &{headers}
    [Return]    &{combined_headers}
