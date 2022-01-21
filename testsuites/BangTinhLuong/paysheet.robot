*** Settings ***
Library         JSONLibrary
Library         RequestsLibrary
Resource        ../core/enviroment.robot
Resource        ../core/share.robot
Resource        ../core/share_random.robot
Suite setup     Fill enviroment and get token    ${env}
*** Variables ***
${enp_paysheet}           /paysheets
${enp_cancel_paysheet}    /paysheets/cancel-paysheet
${data_cancel_paysheet}   {"Id":[D0],"isCheckPayslipPayment":false,"isCancelPayment":[D1]}
${data_paysheet}          {"startTime":"[D0]","endTime":"[D1]","salaryPeriod":1,"branches":[{"id":[D2]}]}
${enp_autoloading}        /paysheets/auto-loading-and-update-data-source

${startDate}              01/01/2022
${endDate}                31/01/2022
${data_auto_load}         {"modifiedDate":"2022-01-18T17:56:51.3240000"}
${enp_filter_sheets}      /paysheets?skip=0&take=15&OrderByDesc=CreatedDate&BranchIds=[D0]&PaysheetStatuses=[[D1]]
${draft}                  1
${approve}                2
*** TestCases ***
Create paysheet       [Tags]        all    paysheet
    [Documentation]       Thêm mới bảng lương tạm tính
    ${list_format}        Create List                         ${startDate}        ${endDate}         ${branchId}
    ${data_paysheet}      Format String Use [D0] [D1] [D2]    ${data_paysheet}    ${list_format}
    ${resp}               Post Request Json KV                ${session}          ${enp_paysheet}    ${data_paysheet}   200
    ${id_paysheet}        Get Value From Json KV              ${resp}             $.result.id
    Set Suite Variable    ${id_paysheet}                      ${id_paysheet}

Auto loading paysheet   [Tags]        all    paysheet1
    [Documentation]       Tải lại bảng lương tạm tính
    ${id_paysheet}        Get Id In List Paysheets            ${draft}
    ${code_paysheet}      Get value in list KV                ${session}        ${enp_paysheet}/${id_paysheet}                $.result.code
    ${resp}               Update Request KV    ${session}     ${enp_autoloading}/${id_paysheet}     ${data_auto_load}        200

Cancel paysheet                     [Tags]             all            paysheet1
      [Documentation]     Huỷ bỏ bảng lương tạm tính ko hủy phiếu thanh toán
      ${id_paysheet}      Get Id In List Paysheets            ${draft}
      ${code_paysheet}    Get value in list KV              ${session}        ${enp_paysheet}/${id_paysheet}                $.result.code
      ${list_format}      Create List    ${id_paysheet}       false
      ${data_cancel_paysheet}     Format String Use [D0] [D1] [D2]    ${data_cancel_paysheet}    ${list_format}
      ${resp}             Update Request KV    ${session}    ${enp_cancel_paysheet}     ${data_cancel_paysheet}    200

Cancel paysheet and cancel payment                    [Tags]             all            paysheet1
      [Documentation]      Huỷ bỏ bảng lương tạm tính và hủy phiếu thanh toán
      ${id_paysheet}        Get value in list KV              ${session}        ${enp_filter_sheets}                          $..data[?(@.totalPayment >0)]..id
      ${code_paysheet}      Get value in list KV              ${session}        ${enp_paysheet}/${id_paysheet}                $.result.code
      ${list_format}        Create List    ${id_paysheet}     true
      ${data_cancel_paysheet}     Format String Use [D0] [D1] [D2]    ${data_cancel_paysheet}    ${list_format}
      ${resp}             Update Request KV    ${session}    ${enp_cancel_paysheet}     ${data_cancel_paysheet}    200

pay salary at payroll screen
      [Documentation]           Thanh toán lương tại màn hình bảng lương

*** Keywords ***
# Lấy được các trạng thái của bảng lương
Get Id In List Paysheets
    [Arguments]           ${status_paysheet}
    ${list_format}        Create List                         ${branchId}                 ${status_paysheet}
    ${enp_filter_sheets}  Format String Use [D0] [D1] [D2]    ${enp_filter_sheets}        ${list_format}
    Set Suite Variable    ${enp_filter_sheets}   ${enp_filter_sheets}
    ${id_paysheet}        Get value in list KV                ${session}                  ${enp_filter_sheets}           $..data..id
    Return From Keyword   ${id_paysheet}
