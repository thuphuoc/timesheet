***Settings***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Resource   ../core/shift.robot
Suite setup  Fill enviroment and get token    ${env}

***Variables***
${enp_employee}                   /employees
${filter_enp_employee}            /employees?skip=0&take=100&OrderByDesc=id&includeFingerPrint=true&BranchIds=[D0]
${enp_multiple_employee}          /employees/delete-multiple
${enp_pin_code}                   /employees/two-fa-pin?EmployeeId=[D0]&UserId=[D1]
${enp_add_work_schedule}          /timesheets
${enp_delete_work_schedule}       /timesheets/cancelTimeSheet
${enp_get_work_schedule}          /timesheets?skip=0&take=5&OrderByDesc=CreatedDate&employeeId=[D0]&timeSheetStatus=1&isDeleted=false
${data_employee}                  {"id":[D0],"code":"[D1]","name":"[D2]","branchId":[D3],"userId":null,"workBranchIds":[[D4]]}
${data_mutiple_employee}          {"employeeIds":[[D0],[D1],[D2]]}
${data_add_work_schedule}         {"TimeSheet":{"startDate":"[D0]","endDate":"[D1]","employeeId":[D2],"isRepeat":true,"hasEndDate":false,"repeatType":1,"repeatEachDay":1,"branchId":[D3],"branchIds":[[D4]],"timeSheetShifts":[{"shiftIds":"[D5]","repeatDaysOfWeek":null}]}}
${data_del_work_schedule}         {"Id":[D0]}
${data_set_salary}         {"salaryPeriod":1,"mainSalaryRuleValue":{"mainSalaryValueDetails":[{"default":[D0],"mainSalaryHolidays":[{"moneyTypes":2,"type":8,"value":[D1],"isApply":true,"sort":2},{"moneyTypes":2,"type":9,"value":[D2],"isApply":true,"sort":3}]}],"type":2},"overtimeSalaryRuleValue":{"overtimeSalaryDays":[{"value":150,"moneyTypes":2,"type":7,"isApply":true,"sort":0},{"value":200,"moneyTypes":2,"type":6,"isApply":true,"sort":1},{"value":200,"moneyTypes":2,"type":0,"isApply":true,"sort":2},{"value":200,"moneyTypes":2,"type":8,"isApply":true,"sort":3},{"value":300,"moneyTypes":2,"type":9,"isApply":true,"sort":4}]}}
*** Test Cases ***
# Tạo mới nhân viên có thiết lập lương nhưng ko có mẫu lương
Create employee                   [Tags]   all    employee
    [Documentation]               Tạo mới nhân viên  và thiết lập lương ko có mẫu lương hợp lệ
    Set Global Variable           ${random_str}                           ${random_str}
    ${list_format}                Create List                             1235698                   NV${random_number}            ${random_str}         ${branchId}           ${branchId}
    ${list_salary}                Create List                             100000                    200                           300
    ${data}                       Format String Use [D0] [D1] [D2]        ${data_employee}          ${list_format}
    ${data_set_salary}            Format String Use [D0] [D1] [D2]        ${data_set_salary}        ${list_salary}
    ${data}                       Evaluate                                (None,'${data}')
    ${data_set_salary}            Evaluate                                (None,'${data_set_salary}')
    Log        ${data}
    ${formdata}                   Create Dictionary                       employee=${data}          payRate=${data_set_salary}
    Log                           ${formdata}
    ${resp}                       Post Request Use Formdata KV            ${session}                ${enp_employee}               ${formdata}            200
    ${id_employee}                Get Value From Json KV                  ${resp.json()}            $.result.id
    ${code_employee}              Get Value From Json KV                  ${resp.json()}            $.result.code
    Set Global Variable           ${code_employee}                        ${code_employee}
    Set Global Variable           ${id_employee}                          ${id_employee}
    Verify input and output       ${random_str}

Create duplicate employee         [Tags]   all    employee
    [Documentation]               Tạo mới nhân viên trùng mã nhân viên
    ${code_employee}              Get value in list KV                    ${enp_employee}           $.result.data..code
    ${list_format}                Create List                             1235698                   ${code_employee}               ${random_str}        ${branchId}           ${branchId}
    ${data}                       Format String Use [D0] [D1] [D2]        ${data_employee}          ${list_format}
    ${data}                       Evaluate                                (None,'${data}')
    Log    ${data}
    ${formdata}                   Create Dictionary                       employee=${data}
    Log    ${formdata}
    ${resp}                       Post Request Use Formdata KV            ${session}                ${enp_employee}                ${formdata}          400
    ${mess_err}                   Get Value From Json KV                  ${resp.json()}            $.errors..message
    Should Be Equal               ${mess_err}                             Mã nhân viên đã tồn tại trong cửa hàng

Create empty employee             [Tags]   all    employee
    [Documentation]               Tạo mới nhân viên để trống trường tên nhân viên
    ${list_format}                Create List                            1235698                    NV${random_number}              \ \                  ${branchId}           ${branchId}
    ${data}                       Format String Use [D0] [D1] [D2]       ${data_employee}           ${list_format}
    ${data}                       Evaluate                               (None,'${data}')
    Log                           ${data}
    ${formdata}                   Create Dictionary                      employee=${data}
    Log                           ${formdata}
    ${resp}                       Post Request Use Formdata KV           ${session}                 ${enp_employee}               ${formdata}             400
    ${mess_err}                   Get Value From Json KV                 ${resp.json()}             $.errors..message
    Should Be Equal               ${mess_err}                           Tên nhân viên không được để trống

Update employee                   [Tags]   all    employee
    [Documentation]               Cập nhật nhân viên
    ${id_employee}                Get value in list KV                  ${enp_employee}             $.result.data[?(@.id)].id
    ${list}                       Create List                           ${id_employee}              UD${random_number}            Update${random_str}       ${branchId}           ${branchId}
    ${data}                       Format String Use [D0] [D1] [D2]                                  ${data_employee}              ${list}
    ${data}                       Evaluate                                                          (None,'${data}')
    ${formdata}                   Create Dictionary                     employee=${data}
    Log                           ${formdata}
    ${resp}                       Update Request KV Use Formdata KV                                 ${session}                    ${enp_employee}/${id_employee}    ${formdata}    200

Get pin code                      [Tags]   all    employee
    [Documentation]               Láy mã xác nhận cho chấm công gps
    ${EmployeeId}                 Get value in list KV                 ${enp_employee}              $.result.data[?(@.id)].id
    ${list}                       Create List                          ${EmployeeId}                ${user_login}
    ${enp_pin_code}               Format String Use [D0] [D1] [D2]                                  ${enp_pin_code}               ${list}
    ${resp}                       Get Request from KV    ${session}                                 ${enp_pin_code}
    Log  ${resp.json()}

Delete employee                   [Tags]   all    employee
    [Documentation]               Xóa 1 nhân viên
    ${id_employee}                Get value in list KV                ${enp_employee}                             $.result.data[?(@.id)].id
    Delete Request KV             ${session}                          ${enp_employee}/${id_employee}              200

Delete multiple employee          [Tags]   all    employee
    [Documentation]               Xóa nhiều nhân viên cùng 1 lúc
    ${EmployeeId1}                Get value in list KV                ${enp_employee}                 $.result.data[?(@.id)].id
    ${EmployeeId2}                Get value in list KV                ${enp_employee}                 $.result.data[?(@.id)].id
    ${EmployeeId3}                Get value in list KV                ${enp_employee}                 $.result.data[?(@.id)].id
    ${list}                       Create List                         ${EmployeeId1}                  ${EmployeeId2}             ${EmployeeId3}
    ${enp_multiple_employee}      Format String Use [D0] [D1] [D2]    ${enp_multiple_employee}        ${list}
    Delete Multiple Request KV    ${session}                          ${enp_multiple_employee}        ${data_mutiple_employee}   200

# case: nhân viên có chi nhánh trả lương và chi nhánh làm việc có ít nhất 1 chi nhánh chung
Add work schedule                 [Tags]   all    employeet
    [Documentation]               Thêm lịch làm việc cho nhân viên tại MH nhân viên
    ${list_format}                Create List                         ${branchId}
    ${filter_enp_employee}        Format String Use [D0] [D1] [D2]    ${filter_enp_employee}          ${list_format}
    ${id_employee}                Get value in list KV                ${filter_enp_employee}          $.result..id
    ${id_shift}                   Get value in list KV                ${enp_shift_branch}             $.result..id
    ${list_format}                Create List                         12-12-2021                      12-01-2022                    ${id_employee}                ${branchId}     ${branchId}    ${id_shift}
    ${data}                       Format String Use [D0] [D1] [D2]    ${data_add_work_schedule}       ${list_format}
    ${resp}                       Post Request Json KV                ${session}                      ${enp_add_work_schedule}      ${data}                       200

# case: xóa lịch làm việc nhân viên nếu nv lịch làm việc
Delete work schedule              [Tags]   all    employeet
    [Documentation]               Xóa lịch làm việc của nhân viên tại tab lịch làm việc của màn hình nhân viên
    ${id_employee}                Get value in list KV                ${enp_shift_branch}             $.result..id
    ${list_format}                Create List                         ${id_employee}
    ${enp_get_work_schedule}      Format String Use [D0] [D1] [D2]                                    ${enp_get_work_schedule}      ${list_format}
    ${id_work_schedule}           Get value in list KV                ${enp_get_work_schedule}        $.result.data[?(@.id)].id
    ${list_format}                Create List                         ${id_work_schedule}
    ${data_del_work_schedule}     Format String Use [D0] [D1] [D2]    ${data_del_work_schedule}       ${list_format}
    ${resp}                       Update Request KV                   ${session}                      ${enp_delete_work_schedule}   ${data_del_work_schedule}       200
    ${mess_validate}              Get Value From Json KV              ${resp.json()}                  $.message
    Should Be Equal               ${mess_validate}                    Hủy lịch làm việc thành công


***Keywords***
Verify input and output
    [Arguments]   ${input}
    ${name_employee_output}      Get detail from id KV              ${enp_employee}                   ${id_employee}               $.result.name
    Should Be Equal As Strings   ${input}                           ${name_employee_output}
