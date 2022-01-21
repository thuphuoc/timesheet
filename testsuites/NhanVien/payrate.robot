*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Library  DependencyLibrary
Resource        ../core/enviroment.robot
Resource        ../core/share.robot
Resource        ../core/share_random.robot
Resource        ../core/allowance.robot
Resource        ../core/deduction.robot
Suite setup     Fill enviroment and get token    ${env}
Suite Teardown  Phuoc

*** Variables ***
${enp_payrate}      /pay-rate-template
${data_payrate}          {"payRateTemplate":{"name":"[D0]","salaryPeriod":1,"commissionSalaryRuleValue":{"commissionSalaryRuleValueDetails":[{"commissionLevel":10000,"value":1000}],"type":2,"formalityTypes":0},"allowanceRuleValue":{"allowanceRuleValueDetails":[{"allowanceId":[D1],"value":10000,"type":0,"isChecked":true}]},"deductionRuleValue":{"deductionRuleValueDetails":[{"deductionId":[D2],"value":15000,"type":0,"deductionRuleId":2,"deductionTypeId":1,"blockTypeTimeValue":1,"blockTypeMinuteValue":1}]}},"branchId":[D3]}
*** TestCases ***

Create payRateTemplate      [Tags]               all      payrate
    [Documentation]         Tạo mới mẫu lương có chứa phụ cấp, giảm trừ, hoa hồng
    ${id_Allowance}         Create And Get ID Allowance
    ${id_Deduction}         Get Random ID Deduction
    ${list_format}          Create List                             MauLuong ${random_str}        ${id_Allowance}       ${id_Deduction}     ${branchId}
    ${data_payrate}         Format String Use [D0] [D1] [D2]        ${data_payrate}               ${list_format}
    ${resp}                 Post Request Json KV                    ${session}                    ${enp_payrate}        ${data_payrate}    200

*** Keywords ***
Phuoc
    Delete Allowance
