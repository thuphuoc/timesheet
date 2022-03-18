***Settings***
Library     JSONLibrary
Library     RequestsLibrary
Library     Collections
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/bangchamcong/shift.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/nhanvien/employee.robot

***Variables***
${enp_employee}                   /employees
${filter_enp_employee}            /employees?skip=0&take=100&OrderByDesc=id&includeFingerPrint=true&BranchIds=[D0]
${enp_multiple_employee}          /employees/delete-multiple
${enp_pin_code}                   /employees/two-fa-pin?EmployeeId=[D0]&UserId=[D1]
${enp_add_work_schedule}          /timesheets
${enp_shift_branch}               /shifts/multiple-branch/orderby-from-to?BranchIds=[D0]&ShiftIds=
${enp_get_work_schedule}          /timesheets?skip=0&take=5&OrderByDesc=CreatedDate&employeeId=[D0]&timeSheetStatus=1&isDeleted=false
${data_employee}                  {"id":[D0],"code":"[D1]","name":"[D2]","branchId":[D3],"userId":null,"workBranchIds":[[D4]]}
${data_mutiple_employee}          {"employeeIds":[[D0],[D1]]}
${data_add_work_schedule}         {"TimeSheet":{"startDate":"[D0]","endDate":"[D1]","employeeId":[D2],"isRepeat":true,"hasEndDate":false,"repeatType":1,"repeatEachDay":1,"branchId":[D3],"branchIds":[[D4]],"timeSheetShifts":[{"shiftIds":"[D5]","repeatDaysOfWeek":null}]}}
${data_set_salary}         {"salaryPeriod":1,"mainSalaryRuleValue":{"mainSalaryValueDetails":[{"default":[D0],"mainSalaryHolidays":[{"moneyTypes":2,"type":8,"value":[D1],"isApply":true,"sort":2},{"moneyTypes":2,"type":9,"value":[D2],"isApply":true,"sort":3}]}],"type":2},"overtimeSalaryRuleValue":{"overtimeSalaryDays":[{"value":150,"moneyTypes":2,"type":7,"isApply":true,"sort":0},{"value":200,"moneyTypes":2,"type":6,"isApply":true,"sort":1},{"value":200,"moneyTypes":2,"type":0,"isApply":true,"sort":2},{"value":200,"moneyTypes":2,"type":8,"isApply":true,"sort":3},{"value":300,"moneyTypes":2,"type":9,"isApply":true,"sort":4}]}}
${data_fixed_salary}              {"salaryPeriod":1,"mainSalaryRuleValue":{"mainSalaryValueDetails":[{"default":1500000}],"type":4}}
${data_del_work_schedule}         {"Id":[D0]}
${enp_delete_work_schedule}       /timesheets/cancelTimeSheet

***Keywords***
# Tạo mới nhân viên có thiết lập lương nhưng ko có mẫu lương
Create Employee
    [Arguments]                   ${id_employee}                          ${code_employee}          ${name_employee}              ${branchId_salary}    ${branchId_work}      ${default}      ${value_holiday}      ${value}
    ${list_format}                Create List                             ${id_employee}            ${code_employee}              ${name_employee}      ${branchId_salary}    ${branchId_work}
    ${list_salary}                Create List                             ${default}                ${value_holiday}              ${value}
    ${data}                       Format String Use [D0] [D1] [D2]        ${data_employee}          ${list_format}
    ${data_set_salary}            Format String Use [D0] [D1] [D2]        ${data_set_salary}        ${list_salary}
    ${data}                       Evaluate                                (None,'${data}')
    ${data_set_salary}            Evaluate                                (None,'${data_set_salary}')
    Log                           ${data}
    ${formdata}                   Create Dictionary                       employee=${data}          payRate=${data_set_salary}
    Log                           ${formdata}
    ${resp}                       Post Request Use Formdata KV            ${session}                ${enp_employee}               ${formdata}            200
    ${id_employee}                Get Value From Json KV                  ${resp}                   $.result.id
    ${code_employee}              Get Value From Json KV                  ${resp}                   $.result.code
    Set Suite Variable            ${code_employee}                        ${code_employee}
    Set Suite Variable            ${id_employee}                          ${id_employee}
    ${branchId}                   Convert To Number                       ${branchId}
    Verify Input And Output Employee                                      ${code_employee}          ${random_str}             ${branchId}

Create And Get ID Employee
    [Arguments]                   ${id_employee}                          ${code_employee}          ${name_employee}              ${branchId_salary}    ${branchId_work}      ${default}      ${value_holiday}      ${value}
    ${list_format}                Create List                             ${id_employee}            ${code_employee}              ${name_employee}      ${branchId_salary}    ${branchId_work}
    ${data}                       Format String Use [D0] [D1] [D2]        ${data_employee}          ${list_format}
    ${data}                       Evaluate                                (None,'${data}')
    ${formdata}                   Create Dictionary                       employee=${data}
    ${resp}                       Post Request Use Formdata KV            ${session}                ${enp_employee}               ${formdata}            200
    ${id_employee}                Get Value From Json KV                  ${resp}                   $.result.id
    Return From Keyword           ${id_employee}

Format Enp Filter_enp_employee
    ${list_format}                Create List    ${branchId}
    ${filter_enp_employee}        Format String Use [D0] [D1] [D2]       ${filter_enp_employee}    ${list_format}
    Return From Keyword           ${filter_enp_employee}

Get Random ID Employee
    ${filter_enp_employee}        Format Enp Filter_enp_employee
    ${id_employee}                Get Value In List KV    ${session}     ${filter_enp_employee}             $.result.data[?(@.id)].id
    ${code_employee}              Get Value In List KV    ${session}     ${enp_employee}/${id_employee}     $..code
    Return From Keyword           ${id_employee}

Create Duplicate Employee
    ${code_employee}              Get Value In List KV                    ${session}                ${enp_employee}               $.result.data..code
    ${list_format}                Create List                             1235698                   ${code_employee}               ${random_str}        ${branchId}           ${branchId}
    ${data}                       Format String Use [D0] [D1] [D2]        ${data_employee}          ${list_format}
    ${data}                       Evaluate                                (None,'${data}')
    Log    ${data}
    ${formdata}                   Create Dictionary                       employee=${data}
    Log    ${formdata}
    ${resp}                       Post Request Use Formdata KV            ${session}                ${enp_employee}                ${formdata}          400
    ${mess_err}                   Get Value From Json KV                  ${resp}                   $.errors..message
    Should Be Equal               ${mess_err}                             Mã nhân viên đã tồn tại trong cửa hàng

Create Empty Employee
    ${list_format}                Create List                            1235698                    NV${random_number}              \ \                  ${branchId}           ${branchId}
    ${data}                       Format String Use [D0] [D1] [D2]       ${data_employee}           ${list_format}
    ${data}                       Evaluate                               (None,'${data}')
    Log                           ${data}
    ${formdata}                   Create Dictionary                      employee=${data}
    Log                           ${formdata}
    ${resp}                       Post Request Use Formdata KV           ${session}                 ${enp_employee}               ${formdata}             400
    ${mess_err}                   Get Value From Json KV                 ${resp}                    $.errors..message
    Should Be Equal               ${mess_err}                           Tên nhân viên không được để trống

Update Employee
    [Arguments]                   ${id_employee}
    ${list}                       Create List                           ${id_employee}              UD${random_number}            Update${random_str}       ${branchId}           ${branchId}
    ${data}                       Format String Use [D0] [D1] [D2]                                  ${data_employee}              ${list}
    ${data}                       Evaluate                                                          (None,'${data}')
    ${formdata}                   Create Dictionary                     employee=${data}
    Log                           ${formdata}
    ${resp}                       Update Request Json KV Use Formdata KV                            ${session}                   ${enp_employee}/${id_employee}    ${formdata}    200

Get Pin Code
    [Arguments]                   ${id_employee}
    ${list}                       Create List                          ${id_employee}                ${user_login}
    ${enp_pin_code}               Format String Use [D0] [D1] [D2]                                   ${enp_pin_code}            ${list}
    ${resp}                       Get Request From KV                  ${session}                    ${enp_pin_code}

Add Work Schedule
    Format enp shift branch
    ${resp_shift}                 Create Shift                        123456                          ${random_str}              ${branchId}                   200
    ${id_shift}                   Get RanDom ID Shift And Get Name From ID
    ${list_format}                Create List                         12-12-2021                      12-01-2022                 ${id_employee}                ${branchId}     ${branchId}    ${id_shift}
    ${data}                       Format String Use [D0] [D1] [D2]    ${data_add_work_schedule}       ${list_format}
    ${resp}                       Post Request Json KV                ${session}                      ${enp_add_work_schedule}   ${data}                       200
    ${id_work_schedule}           Get Value From Json KV              ${resp}                         $.result.id
    Set Suite Variable            ${id_work_schedule}                 ${id_work_schedule}
# case: xóa lịch làm việc nhân viên nếu nv có lịch làm việc
Delete Work Schedule
    [Arguments]                   ${id_work_schedule}
    ${list_format}                Create List                         ${id_work_schedule}
    ${data_del_work_schedule}     Format String Use [D0] [D1] [D2]    ${data_del_work_schedule}             ${list_format}
    ${resp}                       Update Request Json KV              ${session}                            ${enp_delete_work_schedule}   ${data_del_work_schedule}       200
    ${mess_validate}              Get Value From Json KV              ${resp}                               $.message
    Should Be Equal               ${mess_validate}                    Hủy lịch làm việc thành công

Delete Employee
    [Arguments]                   ${id_employee}
    ${id_employee}                Get Random ID Employee
    Delete Request KV             ${session}                          ${enp_employee}/${id_employee}    200

Delete multiple employee
    ${EmployeeId1}                Get Value In List KV                ${session}                      ${enp_employee}                 $.result.data[?(@.id)].id
    ${code_employee1}             Get Detail From Id KV               ${session}                      ${enp_employee}/${EmployeeId1}  $.result.code
    ${EmployeeId2}                Get Value In List KV                ${session}                      ${enp_employee}                 $.result.data[?(@.id)].id
    ${code_employee2}             Get Detail From Id KV               ${session}                      ${enp_employee}/${EmployeeId2}  $.result.code
    ${list}                       Create List                         ${EmployeeId1}                  ${EmployeeId2}
    ${data_mutiple_employee}      Format String Use [D0] [D1] [D2]    ${data_mutiple_employee}        ${list}
    ${resp}                       Delete Multiple Request KV          ${session}                      ${enp_multiple_employee}        ${data_mutiple_employee}    Xóa nhân viên thành công

Verify Input And Output Employee
    [Arguments]         ${code_input}                      ${name_input}                     ${branch_input}
    ${resp}             Get Request From KV                ${session}                        ${enp_employee}/${id_employee}
    ${code_output}      Get Value From Json KV             ${resp}                           $.result.code
    ${name_output}      Get Value From Json KV             ${resp}                           $.result.name
    ${branch_output}    Get Value From Json KV             ${resp}                           $.result.branchId
    ${branch_output}    Convert To Number                  ${branch_output}
    ${list_input}       Create List                        ${code_input}                     ${name_input}                           ${branch_input}
    ${list_output}      Create List                        ${code_output}                    ${name_output}                          ${branch_output}
    Verify List Input And Output                           ${list_input}                     ${list_output}

Create Employee Fixed Salary
    [Arguments]          ${id_employee}            ${code_employee}          ${name_employee}      ${branchId_salary}    ${branchId_work}
    ${list_format}       Create List               ${id_employee}            ${code_employee}      ${name_employee}      ${branchId_salary}    ${branchId_work}
    ${data_employee}     Format String Use [D0] [D1] [D2]                    ${data_employee}      ${list_format}
    ${data_employee}     Evaluate                                            (None,'${data_employee}')
    ${data_fixed_salary}            Evaluate                                (None,'${data_fixed_salary}')
    ${formdata}          Create Dictionary                                   employee=${data_employee}                   payRate=${data_fixed_salary}
    ${resp}              Post Request Use Formdata KV                        ${session}            ${enp_employee}       ${formdata}            200
    Return From Keyword    ${resp}
