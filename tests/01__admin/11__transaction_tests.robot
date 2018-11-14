*** Settings ***
Documentation     Tests related to transactions
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot

*** Variables ***
${JSON_PATH}      ${RESOURCE_PATH}/transaction

*** Test Cases ***
Create a transaction successfully between 2 addresses specifying and amount
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/create_transaction_addresses.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    from_address=${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}    to_address=${USER_PRIMARY_WALLET_ADDRESS}    token_id=${TOKEN_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction
    Should be Equal    ${resp.json()['data']['from']['token']['id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['from']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['from']['address']}    ${json_data['from_address']}
    Should be Equal    ${resp.json()['data']['to']['token']['id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['to']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['to']['address']}    ${json_data['to_address']}
    ${TRANSACTION_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Suite Variable    ${TRANSACTION_ID}

Create a transaction successfully between 2 addresses specifying a from_amount and an exchange account id
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/create_transaction_exchange_from_amount.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    from_address=${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}    to_address=${USER_PRIMARY_WALLET_ADDRESS}    from_token_id=${TOKEN_ID}    to_token_id=${TOKEN_1_ID}
    ...    exchange_account_id=${MASTER_ACCOUNT_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction
    Should be Equal    ${resp.json()['data']['from']['token']['id']}    ${json_data['from_token_id']}
    Should be Equal    ${resp.json()['data']['from']['amount']}    ${json_data['from_amount']}
    Should be Equal    ${resp.json()['data']['from']['address']}    ${json_data['from_address']}
    Should be Equal    ${resp.json()['data']['to']['token']['id']}    ${json_data['to_token_id']}
    Should be Equal    ${resp.json()['data']['to']['amount']}    ${json_data['from_amount'] * 2}
    Should be Equal    ${resp.json()['data']['to']['address']}    ${json_data['to_address']}
    Should Be Equal    ${resp.json()['data']['exchange']['exchange_account_id']}    ${MASTER_ACCOUNT_ID}

Create a transaction successfully between 2 addresses specifying a to_amount and an exchange wallet address
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/create_transaction_exchange_to_amount.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    from_address=${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}    to_address=${USER_PRIMARY_WALLET_ADDRESS}    from_token_id=${TOKEN_ID}    to_token_id=${TOKEN_1_ID}
    ...    exchange_wallet_address=${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction
    Should be Equal    ${resp.json()['data']['from']['token']['id']}    ${json_data['from_token_id']}
    Should be Equal    ${resp.json()['data']['from']['amount']}    ${json_data['to_amount'] / 2}
    Should be Equal    ${resp.json()['data']['from']['address']}    ${json_data['from_address']}
    Should be Equal    ${resp.json()['data']['to']['token']['id']}    ${json_data['to_token_id']}
    Should be Equal    ${resp.json()['data']['to']['amount']}    ${json_data['to_amount']}
    Should be Equal    ${resp.json()['data']['to']['address']}    ${json_data['to_address']}
    Should Be Equal    ${resp.json()['data']['exchange']['exchange_wallet_address']}    ${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}

Create a transaction successfully between 2 addresses with an amount in string
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/create_transaction_amount_string.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    from_address=${MASTER_ACCOUNT_PRIMARY_WALLET_ADDRESS}    to_address=${USER_PRIMARY_WALLET_ADDRESS}    token_id=${TOKEN_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction
    Should be Equal    ${resp.json()['data']['from']['token']['id']}    ${json_data['token_id']}
    Should Be Equal As Numbers    ${resp.json()['data']['from']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['from']['address']}    ${json_data['from_address']}
    Should be Equal    ${resp.json()['data']['to']['token']['id']}    ${json_data['token_id']}
    Should Be Equal As Numbers    ${resp.json()['data']['to']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['to']['address']}    ${json_data['to_address']}

Create a transaction successfully between 2 accounts
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/create_transaction_accounts.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    from_account_id=${MASTER_ACCOUNT_ID}    to_account_id=${ACCOUNT_ID}    token_id=${TOKEN_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction
    Should be Equal    ${resp.json()['data']['from']['token']['id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['from']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['from']['account_id']}    ${json_data['from_account_id']}
    Should be Equal    ${resp.json()['data']['to']['token']['id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['to']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['to']['account_id']}    ${json_data['to_account_id']}

Create a transaction successfully between an account and a provider_user_id
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/create_transaction_account_to_user.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    from_account_id=${MASTER_ACCOUNT_ID}    to_provider_user_id=${PROVIDER_USER_ID}    token_id=${TOKEN_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction
    Should be Equal    ${resp.json()['data']['from']['token']['id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['from']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['from']['account_id']}    ${json_data['from_account_id']}
    Should be Equal    ${resp.json()['data']['to']['token']['id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['to']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['to']['user']['provider_user_id']}    ${json_data['to_provider_user_id']}

Create a transaction successfully between 2 provider_user_id
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/create_transaction_provider_user_id.json
    ${i_token}    Generate Random String
    &{override}    Create Dictionary    idempotency_token=${i_token}    from_provider_user_id=${PROVIDER_USER_ID}    to_provider_user_id=${PROVIDER_USER_1_ID}    token_id=${TOKEN_ID}
    ${data}    Update Json    ${data}    &{override}
    ${json_data}    To Json    ${data}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_CREATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction
    Should be Equal    ${resp.json()['data']['from']['token']['id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['from']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['from']['user']['provider_user_id']}    ${json_data['from_provider_user_id']}
    Should be Equal    ${resp.json()['data']['to']['token']['id']}    ${json_data['token_id']}
    Should be Equal    ${resp.json()['data']['to']['amount']}    ${json_data['amount']}
    Should be Equal    ${resp.json()['data']['to']['user']['provider_user_id']}    ${json_data['to_provider_user_id']}

Get a transaction successfully
    ${data}    Get Binary File    ${JSON_PATH}/get_transaction.json
    ${data}    Update Json    ${data}    id=${TRANSACTION_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction
    Should be Equal    ${resp.json()['data']['id']}    ${TRANSACTION_ID}

Get all transactions successfully
    ${data}    Get Binary File    ${JSON_PATH}/get_transactions.json
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_ALL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Should Not Be Empty    ${resp.json()['data']['data']}

Calculate a transaction successfully
    ${data}    Get Binary File    ${JSON_PATH}/calculate_transaction.json
    &{override}    Create Dictionary    from_token_id=${TOKEN_ID}    to_token_id=${TOKEN_1_ID}
    ${data}    Update Json    ${data}    &{override}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_CALCULATE}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    transaction_calculation
    Should be Equal    ${resp.json()['data']['from_token_id']}    ${TOKEN_ID}
    Should be Equal    ${resp.json()['data']['to_token_id']}    ${TOKEN_1_ID}
    Should Be Equal As Strings    ${resp.json()['data']['from_amount']}    1
    Should Be Equal As Strings    ${resp.json()['data']['to_amount']}    2
    Should be Equal    ${resp.json()['data']['exchange_pair']['from_token_id']}    ${TOKEN_ID}
    Should be Equal    ${resp.json()['data']['exchange_pair']['to_token_id']}    ${TOKEN_1_ID}
