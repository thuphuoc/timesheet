*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token    zone12

*** Variables ***
${enp_deduction}      /deduction
${data_deduction}     {"deduction":{"name":"[D0]","valueType":1},"deductionDetail":{"value":[D1],"type":"VND","blockTypeTimeValue":1}}
${data_upd_deduction}   {"deduction":{"id":[D0],"name":"[D1]","valueType":1},"deductionDetail":{"value":13000,"type":"VND","deductionRuleId":0,"deductionTypeId":1,"blockTypeTimeValue":1,"blockTypeMinuteValue":1,"valueType":1,"deductionRuleName":"Cố định"}}
*** TestCases ***
Create deduction            [Tags]    Create deduction
    ${list_format}          Create List                         ${random_str}        50000
    ${data_deduction}       Format String Use [D0] [D1] [D2]    ${data_deduction}    ${list_format}
    Post Request Json KV    ${session}    ${enp_deduction}      ${data_deduction}    200
Create duplicate deduction  [Tags]    Create duplicate deduction
    ${name}                 Get value in list KV    ${enp_deduction}    $.result.data..name
    ${list_format}          Create List             ${name}             0     10000
    ${data_deduction}       Format String Use [D0] [D1] [D2]            ${data_deduction}    ${list_format}
    Create value duplicate_empty    ${enp_deduction}                    ${data_deduction}    Giảm trừ đã tồn tại trên hệ thống
 Create empty deduction      [Tags]    Create empty deduction
   ${list_format}            Create List  \ \   12000
   ${data_deduction}         Format String Use [D0] [D1] [D2]    ${data_deduction}    ${list_format}
   Create value duplicate_empty    ${enp_deduction}              ${data_deduction}    Tên giảm trừ không được để trống
Update deduction            [Tags]    Update deduction
    ${id_deduction}         Get value in list KV    ${enp_deduction}    $.result.data..id
    ${list_format}          Create List             ${id_deduction}     Update ${random_str}
    ${data_upd_deduction}   Format String Use [D0] [D1] [D2]            ${data_upd_deduction}    ${list_format}
    Update Request KV       ${session}    ${enp_deduction}/${id_deduction}    ${data_upd_deduction}    200
Delete deduction            [Tags]    Delete deduction
    ${id_deduction}         Get value in list KV    ${enp_deduction}    $.result.data..id
    Delete Request KV       ${session}              ${enp_deduction}/${id_deduction}    200
*** Keywords ***
