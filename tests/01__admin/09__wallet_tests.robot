# TODO We need to have wallets first
*** Settings ***
Documentation    Tests related to users

Resource    admin_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Get all wallets successfully

Get a wallet successfully
