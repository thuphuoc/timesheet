*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Library  DependencyLibrary
Resource        ../core/enviroment.robot
Resource        ../core/share.robot
Resource        ../core/share_random.robot
Resource        shift.robot
Suite setup     Fill enviroment and get token    ${env}
*** Variables ***
${enp_payrate}      /pay-rate-template
${data_payrate}          {"payRateTemplate":{"name":"[D0]","salaryPeriod":1,"commissionSalaryRuleValue":{"commissionSalaryRuleValueDetails":[{"commissionLevel":10000,"value":1000}],"type":2,"formalityTypes":0},"allowanceRuleValue":{"allowanceRuleValueDetails":[{"allowanceId":[D1],"value":10000,"type":0,"isChecked":true}]},"deductionRuleValue":{"deductionRuleValueDetails":[{"deductionId":[D2],"value":15000,"type":0,"deductionRuleId":2,"deductionTypeId":1,"blockTypeTimeValue":1,"blockTypeMinuteValue":1}]}},"branchId":[D3]}
${data}         {"payRateTemplate":{"name":"[D0]","salaryPeriod":1,allowanceRuleValue":{"allowanceRuleValueDetails":[{"allowanceId":[D1],"value":10000,"type":0,"isChecked":true}]},"branchId":[D2]}
*** TestCases ***

Create payRateTemplate      [Tags]        all       payrate
    ${list_format}    Create List                         MauLuong${random_str}      ${id_allowance}     ${branchId}
    ${data}           Format String Use [D0] [D1] [D2]    ${data}                    ${list_format}
    ${resp}           Post Request Json KV                ${session}                 ${enp_payrate}      ${data}    200
*** Keywords ***
