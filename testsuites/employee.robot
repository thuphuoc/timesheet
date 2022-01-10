***Settings***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token    ${env}

***Variables***
${enp_employee}            /employees
${enp_multiple_employee}   /employees/delete-multiple
${enp_pin_code}            /employees/two-fa-pin?EmployeeId=[D0]&UserId=[D1]
${enp_add_work_schedule}   /timesheets
${enp_delete_work_schedule}   /timesheets/cancelTimeSheet
${enp_get_work_schedule}    /timesheets?skip=0&take=5&OrderByDesc=CreatedDate&employeeId=[D0]&timeSheetStatus=1&isDeleted=false
${url}                      https://api-timesheet.kiotviet.vn
${data_employee}            {"name":"[D0]","branchId":[D1],"workBranchIds":[[D2]]}
${data_upd_employee}        {"id":[D0],"code":"[D1]","name":"[D2]","branchId":302728,"userId":null,"workBranchIds":[302728]}
${data_mutiple_employee}    {"employeeIds":[[D0],[D1],[D2]]}
${data_add_work_schedule}   {"TimeSheet":{"startDate":"[D0]","endDate":"[D1]","employeeId":[D2],"isRepeat":true,"hasEndDate":false,"repeatType":1,"repeatEachDay":1,"branchId":302728,"branchIds":[302728],"timeSheetShifts":[{"shiftIds":"30000000113509","repeatDaysOfWeek":null}]}}
${data_del_work_schedule}   {"Id":[D0]}
*** Test Cases ***
Create employee             [Tags]    employee
    [Documentation]   Create   employee valid
    Set Global Variable    ${random_str}   ${random_str}
    ${list_format}         Create List     ${random_str}       ${branchId}           ${branchId}
    ${data}                Format String Use [D0] [D1] [D2]    ${data_employee}      ${list_format}
    ${data}                Evaluate     (None,'${data}')
    Log                    ${data}
    ${formdata}            Create Dictionary    employee=${data}
    Log                    ${formdata}
    ${resp}                Post Request Use Formdata KV   ${session}       ${enp_employee}    ${formdata}   200
    ${id_employee}         Get Value From Json KV         ${resp.json()}   $.result.id
    ${code_employee}       Get Value From Json KV         ${resp.json()}   $.result.code
    Set Global Variable    ${code_employee}    ${code_employee}
    Set Global Variable    ${id_employee}      ${id_employee}
    Verify input and output of add employee    ${random_str}
Create duplicate employee   [Tags]    employee
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
Create empty employee       [Tags]    employee
    ${list_format}      Create List   \ \     ${branchId}     ${branchId}
    ${data}             Format String Use [D0] [D1] [D2]      ${data_employee}      ${list_format}
    ${data}             Evaluate     (None,'${data}')
    Log                 ${data}
    ${formdata}         Create Dictionary    employee=${data}
    Log                 ${formdata}
    ${resp}             Post Request Use Formdata KV   ${session}       ${enp_employee}    ${formdata}   400
    ${mess_err}         Get Value From Json KV         ${resp.json()}   $.errors..message
    Should Be Equal     ${mess_err}    Tên nhân viên không được để trống
# chưa chay đươc
Update employee             [Tags]    employee
    ${list}             Create List     ${id_employee}         ${code_employee}        ${random_str}
    ${data}             Format String Use [D0] [D1] [D2]       ${data_upd_employee}    ${list}
    ${data}             Evaluate    (None,'${data}')
    ${formdata}         Create Dictionary    employee=${data}
    Log    ${formdata}
    ${resp}   Update Request KV Use Formdata KV    ${session}    ${enp_employee}/${id_employee}    ${formdata}    200
Get pin code                [Tags]    employee
    ${EmployeeId}     Get value in list KV    ${enp_employee}     $.result.data[0].id
    ${list}           Create List             ${EmployeeId}       ${user_login}
    ${enp_pin_code}   Format String Use [D0] [D1] [D2]            ${enp_pin_code}    ${list}
    ${resp}           Get Request from KV    ${session}           ${enp_pin_code}
    Log  ${resp.json()}
Delete employee             [Tags]    employee
    ${id_employee}      Get value in list KV    ${enp_employee}                   $.result.data[?(@.id)].id
    Delete Request KV   ${session}              ${enp_employee}/${id_employee}    200
Delete multiple employee    [Tags]    employee
    ${EmployeeId1}   Get value in list KV    ${enp_employee}       $.result.data[?(@.id)].id
    ${EmployeeId2}   Get value in list KV    ${enp_employee}       $.result.data[?(@.id)].id
    ${EmployeeId3}   Get value in list KV    ${enp_employee}       $.result.data[?(@.id)].id
    ${list}          Create List             ${EmployeeId1}        ${EmployeeId2}              ${EmployeeId3}
    ${enp_multiple_employee}   Format String Use [D0] [D1] [D2]    ${enp_multiple_employee}    ${list}
    Delete Multiple Request KV    ${session}                       ${enp_multiple_employee}    ${data_mutiple_employee}     200
# case: nhân viên có chi nhánh trả lương và chi nhánh làm việc có ít nhất 1 chi nhánh chung
Add work schedule           [Tags]    employee
    ${id_employee}      Get value in list KV        ${enp_employee}    $.result.data[?(@.id)].id
    ${list_format}      Create List   12-12-2021    12-01-2022         ${id_employee}
    ${data}             Format String Use [D0] [D1] [D2]      ${data_add_work_schedule}     ${list_format}
    ${resp}             Post Request Json KV    ${session}    ${enp_add_work_schedule}    ${data}    200
# case: nhân viên có lịch làm việc
Delete work schedule        [Tags]    employee
    ${id_employee}              Get value in list KV    ${enp_employee}    $.result.data[?(@.id)].id
    ${list_format}              Create List             ${id_employee}
    ${enp_get_work_schedule}    Format String Use [D0] [D1] [D2]           ${enp_get_work_schedule}    ${list_format}
    ${id_work_schedule}         Get value in list KV    ${enp_get_work_schedule}    $.result.data[?(@.id)].id
    ${list_format}              Create List    ${id_work_schedule}
    ${data_del_work_schedule}   Format String Use [D0] [D1] [D2]    ${data_del_work_schedule}     ${list_format}
    ${resp}                     Update Request KV     ${session}    ${enp_delete_work_schedule}   ${data_del_work_schedule}    200
    ${mess_validate}            Get Value From Json KV    ${resp.json()}    $.message
    Should Be Equal             ${mess_validate}          Hủy lịch làm việc thành công
***Keywords***
Verify input and output of add employee
    [Arguments]   ${input}
    ${name_employee_output}   Get detail from id KV    ${enp_employee}     ${id_employee}    $.result.name
    Should Be Equal As Strings     ${input}      ${name_employee_output}
