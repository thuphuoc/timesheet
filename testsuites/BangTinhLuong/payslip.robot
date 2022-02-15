*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../../core/Share/enviroment.robot
Resource  ../../core/Share/share.robot
Resource   ../../core/Share/share_random.robot
Suite setup  Fill enviroment and get token     ${env}
*** Variables ***
${enp_payslip}        /payslip/getPayslipsByPaysheetId?PaysheetId=[D0]
${enp_paysheet}       /paysheets
${enp_cancel_payslip}   /payslip/cancel-payslip
${data_cancel_payslip}    {"Id":[D0],"isCheckPayslipPayment":true,"isCancelPayment":[D1]}

*** TestCases ***
Delete payslip in paysheet       [Tags]      all         payslip
    [Documentation]             Xóa phiếu lương trong bảng lương nhưng không hủy phiếu thanh toán của phiếu lương
    ${id_paysheet}              Get Value In List KV            ${session}        ${enp_paysheet}                   $..data..id
    ${code_paysheet}            Get Value In List KV            ${session}        ${enp_paysheet}/${id_paysheet}    $.result.code
    ${list_format}              Create List                     ${id_paysheet}
    ${enp_payslip}              Format String Use [D0] [D1] [D2]                  ${enp_payslip}                    ${list_format}
    ${id_payslip}               Get Value In List KV            ${session}        ${enp_payslip}                    $.result.data[?(@.id)].id
    ${list_format}              Create List                     ${id_payslip}     false
    ${data_cancel_payslip}      Format String Use [D0] [D1] [D2]                  ${data_cancel_payslip}            ${list_format}
    ${resp}                     Update Request Json KV          ${session}        ${enp_cancel_payslip}             ${data_cancel_payslip}          200

*** Keywords ***
