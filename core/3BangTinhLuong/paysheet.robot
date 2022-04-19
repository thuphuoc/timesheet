*** Settings ***
Library         JSONLibrary
Library         RequestsLibrary
Resource   ../../core/Share/enviroment.robot
Resource  ../../core/Share/share.robot
Resource   ../../core/Share/share_random.robot

*** Variables ***
${enp_paysheet}                 /paysheets
${enp_cancel_paysheet}          /paysheets/cancel-paysheet
${data_cancel_paysheet}         {"Id":[D0],"isCheckPayslipPayment":false,"isCancelPayment":[D1]}
${data_paysheet}                {"startTime":"[D0]","endTime":"[D1]","salaryPeriod":1,"branches":[{"id":[D2]}]}
${enp_autoloading}              /paysheets/auto-loading-and-update-data-source
${data_payment_paysheet}        {"Paysheet":{"id":[D0],"version":[D1]},"Payslips":[{"Id":[D2],"PayslipPayments":[{"Amount":[D3],"Method":"Cash"}]}]}
${enp_payment_paysheet}         /payslip-payment/make-payments
${enp_payslip_paysheet}         /payslip/getPayslipsByPaysheetId?PaysheetId=[D0]&OrderByDesc=id&payslipStatuses=1&OrderBy=Id
${enp_payslip}                  /payslip/getPayslipsByPaysheetId?PaysheetId=[D0]
${enp_cancel_payslip}           /payslip/cancel-payslip
${data_cancel_payslip}          {"Id":[D0],"isCheckPayslipPayment":true,"isCancelPayment":[D1]}
${startDate}                    01/03/2022
${endDate}                      31/03/2022
${data_auto_load}               {"modifiedDate":"2022-01-18T17:56:51.3240000"}
${enp_filter_sheets}            /paysheets?skip=0&take=15&OrderByDesc=CreatedDate&BranchIds=[D0]&PaysheetStatuses=[[D1]]
${draft}                        1
${approve}                      2
${value_amount}                 11000
*** Keywords ***
Create Paysheet
     ${list_format}             Create List                         ${startDate}              ${endDate}                          ${branchId}
     ${data_paysheet}           Format String Use [D0] [D1] [D2]    ${data_paysheet}          ${list_format}
     ${resp}                    Post Request Json KV                ${session}                ${enp_paysheet}                     ${data_paysheet}            200
     Return From Keyword        ${resp}

Payment Salary At Paysheet
      Format enpoint enp_filter_sheets                        1
      Log                       Điều kiện phải có bảng lương tạm tính có tổng tiền cần trả lớn hơn 0
      ${id_paysheet}            Get Value In List KV               ${session}                ${enp_filter_sheets}                 $..data[?(@.totalNeedPay>0)]..id
      ${code_paysheet}          Get Value In List KV               ${session}                ${enp_paysheet}/${id_paysheet}       $.result.code
      ${version}                Get Value In List KV               ${session}                ${enp_paysheet}/${id_paysheet}       $..version
      ${list_format}            Create List                        ${id_paysheet}
      ${enp_payslip_paysheet}   Format String Use [D0] [D1] [D2]                             ${enp_payslip_paysheet}              ${list_format}
      ${id_payslip}             Get Value In List KV               ${session}                ${enp_payslip_paysheet}              $..data[?(@.totalNeedPay>0)].id
      ${list_format}            Create List                        ${id_paysheet}            ${version}      ${id_payslip}        ${value_amount}
      ${data_payment_paysheet}  Format String Use [D0] [D1] [D2]                             ${data_payment_paysheet}             ${list_format}
      ${resp}                   Post Request Json KV               ${session_man}            ${enp_payment_paysheet}              ${data_payment_paysheet}    200

Cancel Paysheet
      ${id_paysheet}             Get Id In List Paysheets
      ${code_paysheet}           Get Value In List KV                ${session}                ${enp_paysheet}/${id_paysheet}      $.result.code
      ${list_format}             Create List                         ${id_paysheet}            false
      ${data_cancel_paysheet}    Format String Use [D0] [D1] [D2]    ${data_cancel_paysheet}   ${list_format}
      ${resp}                    Update Request Json KV              ${session}                ${enp_cancel_paysheet}              ${data_cancel_paysheet}    200

Get Id In List Paysheets
    Format enpoint enp_filter_sheets                                1
    ${id_paysheet}              Get Value In List KV                ${session}                 ${enp_filter_sheets}               $..data..id
    Return From Keyword         ${id_paysheet}

Format enpoint enp_filter_sheets
    [Arguments]                 ${status_paysheet}
    ${list_format}              Create List                         ${branchId}                ${status_paysheet}
    ${enp_filter_sheets}        Format String Use [D0] [D1] [D2]    ${enp_filter_sheets}       ${list_format}
    Set Suite Variable          ${enp_filter_sheets}                ${enp_filter_sheets}

Auto Loading Paysheet
    ${id_paysheet}              Get Id In List Paysheets
    ${resp}                     Update Request Json KV               ${session}                ${enp_autoloading}/${id_paysheet}    ${data_auto_load}          200
    Return From Keyword         ${resp}
