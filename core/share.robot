***Settings***
Library   JSONLibrary
Library   Collections
Library   RequestsLibrary
Resource  enviroment.robot

***Keywords***
Format String Use [D0] [D1] [D2]
                                    [Arguments]                 ${data_format}              ${list_format}
                                    ${length}                   Get Length                  ${list_format}
                                    :FOR  ${i}  IN RANGE        ${length}
                                    \     ${value_temp}         Get From List               ${list_format}              ${i}
                                    \     ${value_temp}         Convert To String           ${value_temp}
                                    \     ${data_format}        Replace String              ${data_format}              [D${i}]    ${value_temp}
                                    Return From Keyword         ${data_format}

Get Value From Json KV
    [Arguments]                     ${resp_json}                ${json_path}
    ${result}                       Get Value From Json         ${resp_json}                  ${json_path}
    ${lenght}                       Get Length                  ${result}
    ${result}                       Get From List               ${result}    0
    Run Keyword If                  ${lenght}==0                Return From Keyword    ${0}    ELSE   Return From Keyword   ${result}

Get Request from KV
    [Arguments]                     ${session}                  ${endpoint}
    ${resp}                         Get Request                 ${session}    ${endpoint}
    Return From Keyword             ${resp.json()}

Get value in list KV
    [Arguments]                     ${enpoint}                  ${json_path}
    ${resp}                         Get Request                 ${session}                     ${enpoint}
    log                             ${resp.json()}
    ${list}                         Get Value From Json         ${resp.json()}                 ${json_path}
    ${value}=                       Evaluate                    random.choice($list)           random
    Return From Keyword             ${value}

Get detail from id KV
    [Arguments]                     ${enpoint}    ${id}         ${json_path}
    ${resp}                         Get Request from KV         ${session}                     ${enpoint}/${id}
    ${value}                        Get Value From Json KV      ${resp.json()}                 ${json_path}
    Return From Keyword             ${value}

Post Request Json KV
    [Arguments]                     ${session}                  ${endpoint}                     ${data_func}                          ${expected_status_code}
    ${resp}                         Post Request                ${session}                      ${endpoint}    headers=${header}      data=${data_func}
    Should Be Equal As Strings      ${resp.status_code}         ${expected_status_code}
    Return From Keyword             ${resp}

Post Request Use Formdata KV
    [Arguments]                     ${session}                  ${endpoint}    ${data_func}     ${expected_status_code}
    ${resp}                         Post Request                ${session}    ${endpoint}       ${headers_not_contenType}             files=${data_func}
    Should Be Equal As Strings      ${resp.status_code}         ${expected_status_code}
    Return From Keyword             ${resp}

Create value duplicate_empty
    [Arguments]                     ${endpoint}    ${data}      ${mess_err_expected}
    ${resp}                         Post Request Json KV        ${session}      ${endpoint}     ${data}   400
    ${mess_err}                     Get Value From Json KV      ${resp.json()}                  $.errors..message
    Should Be Equal                 ${mess_err}                 ${mess_err_expected}
    Return From Keyword             ${resp}
Update Request KV Use Formdata KV
    [Arguments]                     ${session}                  ${endpoint}    ${data_func}     ${expected_status_code}
    ${resp}                         Put Request                 ${session}    ${endpoint}       headers=${headers_not_contenType}     files=${data_func}
    log  ${resp.json()}
    Should Be Equal As Strings      ${resp.status_code}         ${expected_status_code}
    Return From Keyword             ${resp}

Update Request KV
    [Arguments]                     ${session}                  ${endpoint}      ${data_func}    ${expected_status_code}
    ${resp}                         Put Request                 ${session}    ${endpoint}        headers=${header}                   data=${data_func}
    Should Be Equal As Strings      ${resp.status_code}         ${expected_status_code}
    Return From Keyword             ${resp}

Delete Request KV
    [Arguments]                     ${session}                  ${endpoint}                      ${expected_status_code}
    ${resp}                         Delete Request              ${session}    ${endpoint}
    Should Be Equal As Strings      ${resp.status_code}         ${expected_status_code}
    Return From Keyword             ${resp}

Delete Multiple Request KV
    [Arguments]                     ${session}                  ${endpoint}   ${data}           ${expected_status_code}
    ${resp}                         Post Request                ${session}    ${endpoint}       ${header}                             ${data}
    Should Be Equal As Strings      ${resp.status_code}         ${expected_status_code}
