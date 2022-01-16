*** Settings ***
Library         JSONLibrary
Library         RequestsLibrary
Resource        ../core/enviroment.robot
Resource        ../core/share.robot
Resource        ../core/share_random.robot
Suite setup     Fill enviroment and get token    ${env}
*** Variables ***
${enp_paysheet}           /paysheets
${data_paysheet}          {"startTime":"[D0]","endTime":"[D1]","salaryPeriod":1,"branches":[{"id":[D2]}]}
${enp_autoloading}        /paysheets/auto-loading-and-update-data-source
${startDate}              01/01/2022
${endDate}                31/01/2022

*** TestCases ***
Create paysheet       [Tags]        all    paysheet
    [Documentation]       Thêm mới bảng lương
    ${list_format}        Create List                         ${startDate}        ${endDate}         ${branchId}
    ${data_paysheet}      Format String Use [D0] [D1] [D2]    ${data_paysheet}    ${list_format}
    ${resp}               Post Request Json KV                ${session}          ${enp_paysheet}    ${data_paysheet}   200
    ${id_paysheet}        Get Value From Json KV              ${resp}             $.result.id
    Set Suite Variable    ${id_paysheet}                      ${id_paysheet}

Auto loading paysheet   [Tags]        all    paysheet
  ${resp}               Update Request KV    ${session}       ${enp_autoloading}/${id_paysheet}     \ \        200
*** Keywords ***
