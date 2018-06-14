*** Settings ***
Documentation    Tests related to wallets

Resource    admin_resources.robot

Suite Setup     Create API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Create a wallet successfully
    # Build payload
    ${data}         Get Binary File    ${RESOURCE}/create_wallet.json
    ${name}         Generate Random String
    &{override}     Create Dictionary    name=${name}    account_id=${ACCOUNT_ID}
    ${data}         Update Json     ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_WALLET_CREATE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success         ${resp}
    Assert Object Type              ${resp}    wallet
    Should be Equal                 ${resp.json()['data']['name']}                  ${json_data['name']}
    Should be Equal                 ${resp.json()['data']['account_id']}            ${json_data['account_id']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}              ${json_data['metadata']}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}    ${json_data['encrypted_metadata']}

    ${WALLET_ADDRESS}          Get Variable Value    ${resp.json()['data']['address']}
    Set Suite Variable         ${WALLET_ADDRESS}

Get all wallets successfully
    # Build payload
    ${data}         Get Binary File    ${RESOURCE}/get_wallets.json
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_WALLET_ALL}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type         ${resp}    list
    Should Not Be Empty        ${resp.json()['data']['data']}

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
