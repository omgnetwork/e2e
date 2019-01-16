*** Settings ***
Documentation     Tests related to exports
Suite Setup       Create Admin API Session
Suite Teardown    Delete All Sessions
Resource          admin_resources.robot

*** Variables ***
${JSON_PATH}      ${RESOURCE_PATH}/export

*** Test Cases ***
Generate a local export for a filtered list of transactions successfully
    # Build payload
    ${data}    Build transaction query payload
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_EXPORT}    data=${data}    headers=${headers}
    # Assert response
    Assert generated export from response with adapter type    ${resp}    local
    ${TRANSACTION_EXPORT_LOCAL_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Suite Variable    ${TRANSACTION_EXPORT_LOCAL_ID}

Get a local export successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_export.json
    ${data}    Update Json    ${data}    id=${TRANSACTION_EXPORT_LOCAL_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXPORT_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    export
    Should Be Equal    ${resp.json()['data']['id']}    ${TRANSACTION_EXPORT_LOCAL_ID}
    Sleep    1s

Download a valid local export successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/download_export.json
    ${data}    Update Json    ${data}    id=${TRANSACTION_EXPORT_LOCAL_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXPORT_DOWNLOAD}    data=${data}    headers=${headers}
    Assert transaction CSV content    ${resp.content}

Update configuration successfully and set the file storage adapter to aws
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_configuration.json
    ${data}    Update Json    ${data}    file_storage_adapter=aws
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_UPDATE_CONFIGURATION}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    map
    Should Be Equal    ${resp.json()['data']['data']['file_storage_adapter']['value']}    aws

Generate an aws export for a filtered list of transactions successfully
    # Build payload
    ${data}    Build transaction query payload
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_EXPORT}    data=${data}    headers=${headers}
    # Assert response
    Assert generated export from response with adapter type    ${resp}    aws
    ${TRANSACTION_EXPORT_AWS_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Suite Variable    ${TRANSACTION_EXPORT_AWS_ID}
    Sleep    1s

Get an aws export successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_export.json
    ${data}    Update Json    ${data}    id=${TRANSACTION_EXPORT_AWS_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXPORT_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    export
    Should Be Equal    ${resp.json()['data']['id']}    ${TRANSACTION_EXPORT_AWS_ID}
    ${TRANSACTION_EXPORT_AWS_DOWNLOAD_URL}    Get Variable Value    ${resp.json()['data']['download_url']}
    Set Suite Variable    ${TRANSACTION_EXPORT_AWS_DOWNLOAD_URL}

Download a valid export from aws successfully
    Create Session    aws_download    ${TRANSACTION_EXPORT_AWS_DOWNLOAD_URL}    timeout=15
    ${resp}    Get Request    aws_download    ${EMPTY}
    Assert transaction CSV content    ${resp.content}

Update configuration successfully and set the file storage adapter to gcs
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_configuration.json
    ${data}    Update Json    ${data}    file_storage_adapter=gcs
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_UPDATE_CONFIGURATION}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    map
    Should Be Equal    ${resp.json()['data']['data']['file_storage_adapter']['value']}    gcs

Generate a gcs export for a filtered list of transactions successfully
    # Build payload
    ${data}    Build transaction query payload
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_EXPORT}    data=${data}    headers=${headers}
    # Assert response
    Assert generated export from response with adapter type    ${resp}    gcs
    ${TRANSACTION_EXPORT_GCS_ID}    Get Variable Value    ${resp.json()['data']['id']}
    Set Suite Variable    ${TRANSACTION_EXPORT_GCS_ID}
    Sleep    1s

Get a gcs export successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_export.json
    ${data}    Update Json    ${data}    id=${TRANSACTION_EXPORT_GCS_ID}
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXPORT_GET}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    export
    Should Be Equal    ${resp.json()['data']['id']}    ${TRANSACTION_EXPORT_GCS_ID}
    ${TRANSACTION_EXPORT_GCS_DOWNLOAD_URL}    Get Variable Value    ${resp.json()['data']['download_url']}
    Set Suite Variable    ${TRANSACTION_EXPORT_GCS_DOWNLOAD_URL}

Download a valid export from gcs successfully
    Create Session    gcs_download    ${TRANSACTION_EXPORT_GCS_DOWNLOAD_URL}    timeout=15
    ${resp}    Get Request    gcs_download    ${EMPTY}
    Assert transaction CSV content    ${resp.content}

Get all exports successfully
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/get_exports.json
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_EXPORT_ALL}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    list
    Length Should Be    ${resp.json()['data']['data']}    3

Update configuration successfully and set the file storage adapter back to local
    # Build payload
    ${data}    Get Binary File    ${JSON_PATH}/update_configuration.json
    ${data}    Update Json    ${data}    file_storage_adapter=local
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_UPDATE_CONFIGURATION}    data=${data}    headers=${headers}
    # Assert response
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    map
    Should Be Equal    ${resp.json()['data']['data']['file_storage_adapter']['value']}    local

*** Keywords ***
Assert generated export from response with adapter type
    [Arguments]    ${resp}    ${adapter_type}
    Assert Response Success    ${resp}
    Assert Object Type    ${resp}    export
    Should Be Equal As Numbers    ${resp.json()['data']['completion']}    1.0
    Should be Equal    ${resp.json()['data']['status']}    processing
    Should be Equal    ${resp.json()['data']['adapter']}    ${adapter_type}

Build transaction query payload
    ${data}    Get Binary File    ${JSON_PATH}/transaction_export.json
    &{match_all_values}    Create Dictionary    field=to_account.id    value=${ACCOUNT_ID}    comparator=eq
    ${match_all_list}    Create List    ${match_all_values}
    &{override}    Create Dictionary    match_all=${match_all_list}
    ${data}    Update Json    ${data}    &{override}
    [Return]    ${data}

Get header row from csv
    [Arguments]    ${csv_content}
    ${header_row_line}    Get Line    ${CSV_CONTENT}    0
    ${header_row_string}    Convert To String    ${header_row_line}
    ${header_row_list}    Split String    ${header_row_string}    separator=,
    [Return]    @{header_row_list}

Get first data row from csv
    [Arguments]    ${csv_content}
    ${first_row_line}    Get Line    ${csv_content}    1
    ${first_row_string}    Convert To String    ${first_row_line}
    ${first_row_list}    Split String    ${first_row_string}    separator=,
    [Return]    @{first_row_list}

Get expected transaction list
    ${data}    Build transaction query payload
    &{headers}    Build Authenticated Admin Request Header
    # Perform request
    ${resp}    Post Request    api    ${ADMIN_TRANSACTION_ALL}    data=${data}    headers=${headers}
    [Return]    ${resp.json()['data']['data']}

Assert transaction CSV content
    [Arguments]    ${csv_content}
    @{header_row}    Get header row from csv    ${csv_content}
    @{first_row}    Get first data row from csv    ${csv_content}
    ${record_count}    Get Line Count    ${csv_content}
    ${expected_headers}    Create List    id    idempotency_token    from_user_id    from_account_id    from_address
    ...    from_amount    from_token_id    from_token_subunit_to_unit    to_user_id    to_account_id    to_address
    ...    to_amount    to_token_id    to_token_subunit_to_unit    exchange_rate    exchange_rate_calculated_at    exchange_pair_id
    ...    exchange_account_id    exchange_wallet_address    metadata    encrypted_metadata    status    error_code
    ...    error_description    created_at    updated_at
    Lists Should Be Equal    ${header_row}    ${expected_headers}
    ${expected_transactions}    Get expected transaction list
    ${expected_count}    Get length    ${expected_transactions}
    Should Be Equal As Numbers    ${record_count-1}    ${expected_count}
    ${transaction}    Get From List    ${expected_transactions}    0
    ${from_user_id}    Evaluate    "" if $transaction["from"]["user_id"] is None else $transaction["from"]["user_id"]
    ${from_account_id}    Evaluate    "" if $transaction["from"]["account_id"] is None else $transaction["from"]["account_id"]
    ${from_amount}    Convert To String    ${transaction["from"]["amount"]}
    ${from_token_subunit_to_unit}    Convert To String    ${transaction["from"]["token"]["subunit_to_unit"]}
    ${to_user_id}    Evaluate    "" if $transaction["to"]["user_id"] is None else $transaction["to"]["user_id"]
    ${to_account_id}    Evaluate    "" if $transaction["to"]["account_id"] is None else $transaction["to"]["account_id"]
    ${to_amount}    Convert To String    ${transaction["to"]["amount"]}
    ${to_token_subunit_to_unit}    Convert To String    ${transaction["to"]["token"]["subunit_to_unit"]}
    ${rate}    Convert To String    ${transaction["exchange"]["rate"]}
    ${exchange_pair_id}    Evaluate    "" if $transaction["exchange"]["exchange_pair_id"] is None else $transaction["exchange"]["exchange_pair_id"]
    ${exchange_account_id}    Evaluate    "" if $transaction["exchange"]["exchange_account_id"] is None else $transaction["exchange"]["exchange_account_id"]
    ${exchange_wallet_address}    Evaluate    "" if $transaction["exchange"]["exchange_wallet_address"] is None else $transaction["exchange"]["exchange_wallet_address"]
    ${error_code}    Evaluate    "" if $transaction["error_code"] is None else $transaction["error_code"]
    ${error_description}    Evaluate    "" if $transaction["error_description"] is None else $transaction["error_description"]
    ${metadata}    Convert To String    ${transaction["metadata"]}
    ${encrypted_metadata}    Convert To String    ${transaction["encrypted_metadata"]}
    ${expected_first_row}    Create List    ${transaction["id"]}    ${transaction["idempotency_token"]}    ${from_user_id}    ${from_account_id}    ${transaction["from"]["address"]}
    ...    ${from_amount}    ${transaction["from"]["token"]["id"]}    ${from_token_subunit_to_unit}    ${to_user_id}    ${to_account_id}    ${transaction["to"]["address"]}
    ...    ${to_amount}    ${transaction["to"]["token"]["id"]}    ${to_token_subunit_to_unit}    ${rate}    ${transaction["exchange"]["calculated_at"]}    ${exchange_pair_id}
    ...    ${exchange_account_id}    ${exchange_wallet_address}    ${metadata}    ${encrypted_metadata}    ${transaction["status"]}    ${error_code}
    ...    ${error_description}    ${transaction["created_at"]}    ${transaction["updated_at"]}
    Lists Should Be Equal    ${first_row}    ${expected_first_row}
