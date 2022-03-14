*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/nhanvien/employee.robot
Suite setup  Fill enviroment and get token     ${env}

*** Variables ***
${enp_payment}          /payslip-payments
${data_payment}         {"PayslipPayments":[{"Amount":[D0],"EmployeeId":[D1],"Method":"[D2]","TransDate":"[D3]"}],"Paysheets":[[D4]]}
${amount}               10000
${method}               Cash
# date không được phép lớn hơn ngày hệ thống
${date}                 10/01/2022
*** TestCases ***
Payment not distributed to payslip   [Tags]              allretailer      allfnb          allbooking            payment
      [Documentation]             Thanh toán bằng tiền mặt không phân bổ vào phiếu lương
      ${id_employee}              Get Random ID Employee
      ${list_format}              Create List    ${amount}            ${id_employee}          ${method}             ${date}               \ \
      ${data_payment}             Format String Use [D0] [D1] [D2]    ${data_payment}         ${list_format}
      ${resp}                     Post Request Json KV                ${session_man}          ${enp_payment}        ${data_payment}         200


*** Keywords ***
