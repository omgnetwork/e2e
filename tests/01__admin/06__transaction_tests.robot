# TODO We need 2 addresses first
*** Settings ***
Documentation    Tests related to users

Resource    admin_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Get all transasctions successfully

Get a transaction successfully

Create a transaction successfully
