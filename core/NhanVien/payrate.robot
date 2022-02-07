*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Library  DependencyLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Suite setup     Fill enviroment and get token    ${env}

*** Variables ***
${enp_payrate}      /pay-rate-template
${data_payrate}          {"payRateTemplate":{"name":"[D0]","salaryPeriod":1,"commissionSalaryRuleValue":{"commissionSalaryRuleValueDetails":[{"commissionLevel":10000,"value":1000}],"type":2,"formalityTypes":0},"allowanceRuleValue":{"allowanceRuleValueDetails":[{"allowanceId":[D1],"value":10000,"type":0,"isChecked":true}]},"deductionRuleValue":{"deductionRuleValueDetails":[{"deductionId":[D2],"value":15000,"type":0,"deductionRuleId":2,"deductionTypeId":1,"blockTypeTimeValue":1,"blockTypeMinuteValue":1}]}},"branchId":[D3]}

*** Keywords ***
Create PayRateTemplate
    [Arguments]             ${id_Allowance}                ${id_Deduction}
    ${list_format}          Create List                             MauLuong ${random_str}        ${id_Allowance}       ${id_Deduction}     ${branchId}
    ${data_payrate}         Format String Use [D0] [D1] [D2]        ${data_payrate}               ${list_format}
    ${resp}                 Post Request Json KV                    ${session}                    ${enp_payrate}        ${data_payrate}    200

Get Name PayRateTemplate
    [Arguments]             ${id_payrate}            ${resp_json}
    ${name_payrate}         Get Value From Json      ${resp_json}    $..id
    Return From Keyword     ${name_payrate}

Update PayRateTemplate
