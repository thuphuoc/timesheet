***Settings***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token   zone12

***Variables***
${enp_employee}           /employees
${enp_multiple_employee}  /employees/delete-multiple
${enp_pin_code}           /employees/two-fa-pin?EmployeeId=[D0]&UserId=[D1]
${url}                    https://api-timesheet.kiotviet.vn
${data_employee}          {"name":"[D0]","branchId":[D1],"workBranchIds":[[D2]]}
${data_upd_employee}      {"id":[D0],"code":"[D1]","name":"[D2]","branchId":302728,"userId":null,"workBranchIds":[302728}
${data_mutiple_employee}  {"employeeIds":[[D0],[D1],[D2]]}
*** Test Cases ***
Create employee     [Tags]    employee
    [Documentation]   Create   employee valid
    Set Global Variable    ${random_str}   ${random_str}
    ${list_format}         Create List     ${random_str}    ${branchId}     ${branchId}
    ${data}   Format String Use [D0] [D1] [D2]    ${data_employee}      ${list_format}
    ${data}   Evaluate     (None,'${data}')
    Log    ${data}
    ${formdata}   Create Dictionary    employee=${data}
    Log    ${formdata}
    ${resp}           Post Request Use Formdata KV   ${session}       ${enp_employee}    ${formdata}   200
    ${id_employee}    Get Value From Json KV         ${resp.json()}   $.result.id
    ${code_employee}  Get Value From Json KV         ${resp.json()}   $.result.code
    Set Global Variable      ${code_employee}    ${code_employee}
    Set Global Variable      ${id_employee}      ${id_employee}
    Verify input and output of add employee      ${random_str}
Create duplicate employee
    ${code_employee}    Get value in list KV    ${enp_employee}    $.result.data..code
    ${list_format}      Create List   \ \       ${code_employee}   ${random_str}
    ${data}   Format String Use [D0] [D1] [D2]    ${data_upd_employee}      ${list_format}
    ${data}   Evaluate     (None,'${data}')
    Log    ${data}
    ${formdata}   Create Dictionary    employee=${data}
    Log    ${formdata}
    ${resp}           Post Request Use Formdata KV   ${session}       ${enp_employee}    ${formdata}   400
    ${mess_err}       Get Value From Json KV    ${resp.json()}        $.errors..message
    Should Be Equal    ${mess_err}    Mã nhân viên đã tồn tại trong cửa hàng
Create empty employee
    ${list_format}      Create List   \ \       ${branchId}     ${branchId}
    ${data}   Format String Use [D0] [D1] [D2]    ${data_employee}      ${list_format}
    ${data}   Evaluate     (None,'${data}')
    Log    ${data}
    ${formdata}   Create Dictionary    employee=${data}
    Log    ${formdata}
    ${resp}           Post Request Use Formdata KV   ${session}       ${enp_employee}    ${formdata}   400
    ${mess_err}       Get Value From Json KV    ${resp.json()}        $.errors..message
    Should Be Equal    ${mess_err}    Tên nhân viên không được để trống
Update employee      [Tags]    update employee
    ${list}   Create List     ${id_employee}   ${code_employee}   ${random_str}
    ${data}   Format String Use [D0] [D1] [D2]       ${data_upd_employee}    ${list}
    ${data}   Evaluate    (None,'${data}')
    ${formdata}   Create Dictionary    employee=${data}
    Log    ${formdata}
    ${resp}   Update Request KV Use Formdata KV    ${session}    ${enp_employee}/${id_employee}    ${formdata}    200
Get pin code         [Tags]    get pin code
    ${EmployeeId}   Get value in list KV    ${enp_employee}    $.result.data[0].id
    ${list}   Create List    ${EmployeeId}    ${user_login}
    ${enp_pin_code}   Format String Use [D0] [D1] [D2]    ${enp_pin_code}    ${list}
    ${resp}   Get Request from KV    ${session}    ${enp_pin_code}
    Log  ${resp.json()}
Delete employee      [Tags]    delete employee
    ${id_employee}    Get value in list KV     ${enp_employee}    $.result.data..id
    Delete Request KV    ${session}    ${enp_employee}/${id_employee}    200
Delete multiple employee
    ${EmployeeId1}   Get value in list KV    ${enp_employee}    $.result.data..id
    ${EmployeeId2}   Get value in list KV    ${enp_employee}    $.result.data..id
    ${EmployeeId3}   Get value in list KV    ${enp_employee}    $.result.data..id
    ${list}          Create List             ${EmployeeId1}     ${EmployeeId2}     ${EmployeeId3}
    ${enp_multiple_employee}   Format String Use [D0] [D1] [D2]    ${enp_multiple_employee}    ${list}
    Delete Multiple Request KV    ${session}     ${enp_multiple_employee}     ${data_mutiple_employee}     200

***Keywords***
Verify input and output of add employee
    [Arguments]   ${input}
    ${name_employee_output}   Get detail from id KV    ${enp_employee}     ${id_employee}    $.result.name
    Should Be Equal As Strings     ${input}      ${name_employee_output}
