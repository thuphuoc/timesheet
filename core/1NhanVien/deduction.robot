*** Settings ***
Resource        ../../core/share/share.robot
*** Variables ***
${enp_deduction}                    /deduction
${data_deduction}                   {"deduction":{"id":[D0],"name":"[D1]","valueType":[D2]},"deductionDetail":{"value":[D3],"type":"[D4]","isLate":false,"deductionRuleId":[D5],"deductionTypeId":[D6],"blockTypeTimeValue":1,"blockTypeMinuteValue":3}}

*** Keywords ***
Get Random ID Deduction
    ${id_Deduction}               Get Value In List KV                  ${session}              ${enp_deduction}         $.result.data..id
    ${name_deduction}             Get Value In List KV                  ${session}              ${enp_deduction}/${id_Deduction}                    $.name
    Return From Keyword           ${id_Deduction}

Create Deduction
    [Arguments]                    ${id}                                 ${name}               ${valueType}              ${value}                  ${type}      ${deductionRuleId}        ${deductionTypeId}      ${expected_statusCode}
    ${list_format}                 Create List                           ${id}                 ${name}                   ${valueType}              ${value}     ${type}   ${deductionRuleId}            ${deductionTypeId}
    ${data_deduction}              Format String Use [D0] [D1] [D2]      ${data_deduction}     ${list_format}
    ${resp}                        Post Request Json KV                  ${session}            ${enp_deduction}          ${data_deduction}         ${expected_statusCode}
    Return From Keyword            ${resp}

Create Deduction And Get ID Deduction
    [Arguments]                    ${id}                                 ${name}               ${valueType}             ${value}                    ${type}       ${deductionRuleId}            ${deductionTypeId}
    ${id_Deduction}               Random a Number    8
    ${resp}                       Create Deduction                       ${id_Deduction}       ${name}                  ${valueType}                ${value}      ${type}        ${deductionRuleId}            ${deductionTypeId}       200
    ${id_Deduction}               Get Value From Json KV                 ${resp}               $.result.id
    Return From Keyword           ${id_Deduction}

Update Deduction
    [Arguments]                   ${name}      ${valueType}             ${value}               ${type}                  ${deductionRuleId}          ${deductionTypeId}
    ${id_Deduction}               Get Random ID Deduction
    ${list_format}                Create List     ${id_Deduction}       ${name}                ${valueType}             ${value}   ${type}           ${deductionRuleId}            ${deductionTypeId}
    ${data_deduction}             Format String Use [D0] [D1] [D2]      ${data_deduction}      ${list_format}
    ${resp}                       Update Request Json KV   ${session}   ${enp_deduction}/${id_Deduction}                ${data_deduction}           200

Get Name Deduction
    ${name}                       Get Value In List KV    ${session}    ${enp_deduction}       $.result.data..name
    Return From Keyword           ${name}

Delete Deduction
    ${id_deduction}               Get Random ID Deduction
    Delete Request KV             ${session}                            ${enp_deduction}/${id_deduction}                200
