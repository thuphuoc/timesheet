*** Settings ***
Resource   share.robot
Resource   share_random.robot

*** Variables ***
${enp_deduction}                    /deduction
${data_deduction}                   {"deduction":{"id":[D0],"name":"[D1]","valueType":[D2]},"deductionDetail":{"value":15000,"type":"VND","isLate":false,"deductionRuleId":[D3],"deductionTypeId":[D4],"blockTypeTimeValue":1,"blockTypeMinuteValue":1}}

*** Keywords ***
Get Random ID Deduction
    ${id_Deduction}               Get value in list KV    ${session}    ${enp_deduction}    $.result.data..id
    Return From Keyword           ${id_Deduction}

Create Deduction
    [Arguments]                     ${id}                                 ${name}               ${valueType}              ${deductionRuleId}        ${deductionTypeId}      ${expected_statusCode}
    ${list_format}                  Create List                           ${id}                 ${name}                   ${valueType}              ${deductionRuleId}            ${deductionTypeId}
    ${data_deduction}               Format String Use [D0] [D1] [D2]      ${data_deduction}     ${list_format}
    ${resp}                         Post Request Json KV                  ${session}            ${enp_deduction}          ${data_deduction}         ${expected_statusCode}
    Return From Keyword             ${resp}

Create Deduction And Get ID Đeuction
    [Arguments]                    ${id}                                 ${name}               ${valueType}              ${deductionRuleId}            ${deductionTypeId}
    ${id_Deduction}               Random a Number    8
    ${resp}                       Create Deduction                       ${id_Deduction}      ${random_str}               1                  20000      200
    ${id_Deduction}               Get Value From Json KV                 ${resp}              $.result.id
    Return From Keyword           ${id_Deduction}

Update Deduction
    [Arguments]                   ${name}               ${valueType}              ${deductionRuleId}            ${deductionTypeId}
    ${id_Deduction}               Get Random ID Deduction
    ${list_format}                Create List     ${id_Deduction}                ${name}               ${valueType}              ${deductionRuleId}            ${deductionTypeId}
    ${data_deduction}             Format String Use [D0] [D1] [D2]      ${data_deduction}    ${list_format}
    ${resp}                       Update Request KV    ${session}    ${enp_deduction}/${id_Deduction}    ${data_deduction}      200

Get Name Deduction
    ${name}                       Get value in list KV    ${session}    ${enp_deduction}      $.result.data..name
    Return From Keyword           ${name}

Delete deduction
    ${id_deduction}                Get Random ID Deduction
    Delete Request KV               ${session}                          ${enp_deduction}/${id_deduction}    200
