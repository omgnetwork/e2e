*** Settings ***
Documentation    Tests related to transactions

Resource    admin_resources.robot

Suite Setup     Create Admin API Session
Suite Teardown  Delete All Sessions

*** Test Cases ***
Create a transaction successfully
    # Build payload
    ${data}         Get Binary File    ${RESOURCE}/create_transaction.json
    ${i_token}      Generate Random String
    &{override}     Create Dictionary    idempotency_token=${i_token}
    ...                                  from_address=${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}
    ...                                  to_address=${USER_PRIMARY_WALLET_ADDRESS}
    ...                                  token_id=${TOKEN_ID}
    ${data}         Update Json     ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_CREATE}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success         ${resp}
    Assert Object Type              ${resp}    transaction
    Should be Equal                 ${resp.json()['data']['from']['token']['id']}    ${json_data['token_id']}
    Should be Equal                 ${resp.json()['data']['from']['amount']}         ${json_data['amount']}
    Should be Equal                 ${resp.json()['data']['to']['token']['id']}      ${json_data['token_id']}
    Should be Equal                 ${resp.json()['data']['to']['amount']}           ${json_data['amount']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}               ${json_data['metadata']}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}     ${json_data['encrypted_metadata']}

    ${TRANSACTION_ID}               Get Variable Value    ${resp.json()['data']['id']}
    Set Suite Variable              ${TRANSACTION_ID}

Get a transaction successfully
    ${data}         Get Binary File    ${RESOURCE}/get_transaction.json
    ${data}         Update Json     ${data}    id=${TRANSACTION_ID}
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_GET}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success         ${resp}
    Assert Object Type              ${resp}    transaction
    Should be Equal                 ${resp.json()['data']['id']}    ${TRANSACTION_ID}

Get all transactions successfully
    ${data}         Get Binary File    ${RESOURCE}/get_transactions.json
    &{headers}      Build Authenticated Admin Request Header

    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_ALL}    data=${data}    headers=${headers}

    # Assert response
    Assert Response Success         ${resp}
    Assert Object Type              ${resp}    list
    Should Not Be Empty             ${resp.json()['data']['data']}
