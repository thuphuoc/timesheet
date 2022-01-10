*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token    ${env}

*** Variables ***
${enp_allowance}          /allowance
${data_allowance}         {"allowance":{"Name":"[D0]","Type":[D1],"Value":[D2],"ValueRatio":0,"IsChecked":true}}
*** TestCases ***
Create allowance        [Tags]    allowance
    ${list_format}      Create List                         ${random_str}       1    20000
    ${data_allowance}   Format String Use [D0] [D1] [D2]    ${data_allowance}   ${list_format}
    ${resp}             Post Request Json KV    ${session}  ${enp_allowance}    ${data_allowance}   200
Create duplicate allowance    [Tags]    allowance
    ${name}             Get value in list KV    ${enp_allowance}    $.result.data..name
    ${list_format}      Create List             ${name}             0     10000
    ${data_allowance}   Format String Use [D0] [D1] [D2]            ${data_allowance}    ${list_format}
    ${resp}             Create value duplicate_empty                ${enp_allowance}     ${data_allowance}    Tên phụ cấp đã tồn tại trên hệ thống
Create empty allowance    [Tags]    allowance
    ${list_format}      Create List     \ \     0           10000
    ${data_allowance}   Format String Use [D0] [D1] [D2]    ${data_allowance}    ${list_format}
    Create value duplicate_empty    ${enp_allowance}        ${data_allowance}    Tên phụ cấp không được để trống
# Update allowance
Delete allowance        [Tags]    allowance
    ${id_allowance}     Get value in list KV    ${enp_allowance}      $.result.data..id
    Delete Request KV   ${session}              ${enp_allowance}/${id_allowance}    200
*** Keywords ***
