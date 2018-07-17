*** Settings ***
Documentation     Tests related to transactions
Suite Setup       Create Client API Session
Suite Teardown    Delete All Sessions
Resource          client_resources.robot

*** Test Cases ***
Create a transfer successfully
    # Build payload
    ${data}    Get Binary File    ${RESOURCE}/create_transaction.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    to_address=${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}    token_id=${TOKEN_ID}    idempotency_token=${i_token}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Request Header
    # Perform request
    ${resp}    Post Request    api    ${CLIENT_CREATE_TRANSACTION}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction
    Should be Equal    ${resp.json()['data']['from']['token']['id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['from']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['to']['token']['id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['to']['amount']}    ${json_data['amount']}
    Dictionaries Should Be Equal    ${resp.json()['data']['metadata']}    ${json_data['metadata']}
    Dictionaries Should Be Equal    ${resp.json()['data']['encrypted_metadata']}    ${json_data['encrypted_metadata']}
    ${TRANSACTION_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Suite Variable    ${TRANSACTION_ID}

Get user's transactions successfully
    ${data}    Get Binary File    ${RESOURCE}/get_transactions.json
    &{headers}    Build Authenticated Request Header
    # Perform request
    ${resp}    Post Request    api    ${CLIENT_GET_TRANSACTIONS}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}
