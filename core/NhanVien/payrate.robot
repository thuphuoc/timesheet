*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Suite setup     Fill enviroment and get token    ${env}

*** Variables ***
${enp_payrate}      /pay-rate-template
${enp_list_payrate}   /pay-rate-template?OrderByDesc=createdDate&branchId=[D0]
${data_payrate}       {"payRateTemplate":{"id":[D0],"name":"[D1]","salaryPeriod":1,"commissionSalaryRuleValue":{"commissionSalaryRuleValueDetails":[{"commissionLevel":10000,"value":1000}],"type":2,"formalityTypes":0},"allowanceRuleValue":{"allowanceRuleValueDetails":[{"allowanceId":[D2],"value":10000,"type":0,"isChecked":true}]},"deductionRuleValue":{"deductionRuleValueDetails":[{"deductionId":[D3],"value":15000,"type":0,"deductionRuleId":2,"deductionTypeId":1,"blockTypeTimeValue":1,"blockTypeMinuteValue":1}]}},"branchId":[D4]}
*** Keywords ***
Create PayRateTemplate
    [Arguments]             ${id_Allowance}                   ${id_Deduction}
    ${list_format}          Create List                       ${random_number}    MauLuong ${random_str}    ${id_Allowance}       ${id_Deduction}     ${branchId}
    ${data_payrate}         Format String Use [D0] [D1] [D2]  ${data_payrate}     ${list_format}
    ${resp}                 Post Request Json KV              ${session}          ${enp_payrate}            ${data_payrate}       200
    Return From Keyword     ${resp}

Format Enp PayRateTemplate
    ${list_format}          Create List                       ${branchId}
    ${enp_list_payrate}     Format String Use [D0] [D1] [D2]  ${enp_list_payrate}    ${list_format}
    Return From Keyword     ${enp_list_payrate}

Get ID And Name PayRateTemplate
    ${enp_list_payrate}     Format Enp PayRateTemplate
    ${id_payrate}           Get Value In List KV             ${session}         ${enp_list_payrate}         $..id
    ${name_payrate}         Get Value In List KV             ${session}         ${enp_payrate}/${id_payrate}   $..name
    Return From Keyword     ${id_payrate}

Update PayRateTemplate
    [Arguments]             ${id_payrate}                    ${name}            ${id_Allowance}             ${id_Deduction}
    ${list_format}          Create List                      ${id_payrate}      Update ${name}              ${id_Allowance}      ${id_Deduction}     ${branchId}
    ${data_payrate}         Format String Use [D0] [D1] [D2]  ${data_payrate}   ${list_format}
    ${resp}                 Update Request Json KV           ${session}         ${enp_payrate}/${id_payrate}   ${data_payrate}   200
    Return From Keyword     ${resp}

Delete PayRateTemplate
    [Arguments]             ${id_payrate}
    ${resp}                 Delete Request KV                   ${session}      ${enp_payrate}/${id_payrate}                    200
