*** Settings ***
Resource   share.robot
Resource   share_random.robot

*** Variables ***
${data_allowance}                   {"allowance":{"Id":"[D0]","Name":"[D1]","Type":[D2],"Value":[D3],"ValueRatio":0,"IsChecked":true}}
${enp_allowance}                    /allowance

*** Keywords ***
Create Allowance
    [Arguments]                     ${id}                                 ${name}               ${type}                   ${value}                      ${expected_statusCode}
    ${list_format}                  Create List                           ${id}                 ${name}                   ${type}                       ${value}
    ${data_allowance}               Format String Use [D0] [D1] [D2]      ${data_allowance}     ${list_format}
    ${resp}                         Post Request Json KV                  ${session}            ${enp_allowance}          ${data_allowance}             ${expected_statusCode}
    Return From Keyword             ${resp}

Create And Get ID Allowance
    ${id_Allowance}                 Random a Number    8
    ${resp}                         Create Allowance                       ${id_Allowance}      ${random_str}               1                  20000      200
    ${id_allowance}                 Get Value From Json KV                 ${resp}              $.result.id
    Return From Keyword             ${id_allowance}

Get Detail Allowance
    [Arguments]                     ${id_Allowance}
    ${respJsonDetail}               Get Request from KV                   ${session}            endpoint
    Return From Keyword             ${respJsonDetail}

Get Random ID Allowance
    ${resp}                         Get Request from KV                   ${session}            ${enp_allowance}
    ${id_allowance}                 Get value in list KV                  ${session}            ${enp_allowance}            $.result.data..id
    Return From Keyword             ${id_allowance}

Update Allowance
    [Arguments]                     ${name}               ${type}         ${value}
    ${id_allowance}                 Get Random ID Allowance
    ${list_format}                  Create List                           ${id_allowance}       ${name}       ${type}                   ${value}
    ${data_allowance}               Format String Use [D0] [D1] [D2]      ${data_allowance}     ${list_format}
    ${resp}                         Update Request KV                     ${session}            ${enp_allowance}/${id_allowance}        ${data_allowance}    200


Delete Allowance
    ${id_Allowance}                 Get value in list KV                  ${session}            ${enp_allowance}     $.result.data..id
    Delete Request KV               ${session}                           ${enp_allowance}/${id_Allowance}             200

Get Name Allowance
    ${name}       Get value in list KV    ${session}    ${enp_allowance}      $.result.data..name
    Return From Keyword     ${name}