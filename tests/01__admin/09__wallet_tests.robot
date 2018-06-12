# TODO We need to have wallets first
*** Settings ***
Documentation    Tests related to users

Resource    admin_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Get all wallets successfully
    # Build payload
    ${data}         Get Binary File    ${RESOURCE}/list_wallets.json
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_WALLET_ALL}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list
    Should Not Be Empty        ${resp.json()['data']['data']}

    ${wallet}                  Get From List         ${resp.json()['data']['data']}    0
    ${WALLET_ADDRESS}          Get Variable Value    ${wallet['address']}
    Set Suite Variable         ${WALLET_ADDRESS}

Get a wallet successfully
    # Build payload
    ${data}         Get Binary File    ${RESOURCE}/get_wallet.json
    ${data}         Update Json        ${data}    address=${WALLET_ADDRESS}
    ${json_data}    To Json            ${data}
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_WALLET_GET}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    wallet
    Should Be Equal            ${resp.json()['data']['address']}    ${WALLET_ADDRESS}
