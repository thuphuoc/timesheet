***Settings***
Library     JSONLibrary
Library     RequestsLibrary
Library     Collections
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/bangchamcong/shift.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/nhanvien/employee.robot
Suite setup     Fill enviroment and get token    ${env}
*** Test Cases ***
Create employee                   [Tags]   all    employee
    [Documentation]               Tạo mới nhân viên  và thiết lập lương ko có mẫu lương
    ${resp}                       Create Employee     1235698           NV${random_number}            ${random_str}         ${branchId}           ${branchId}    100000    200    300

Create duplicate employee         [Tags]   all    employee
    [Documentation]               Tạo mới nhân viên trùng mã nhân viên
    Create Duplicate Employee

Create empty employee             [Tags]   all    employee
    [Documentation]               Tạo mới nhân viên rỗng
    Create Empty Employee

Update employee                   [Tags]   all    employee
    [Documentation]               Cập nhật nhân viên
    Get Random ID Employee
    Update Employee               ${id_employee}
Get pin code                      [Tags]   all    employee
    [Documentation]               Lấy mã xác nhận cho chấm công gps
    Get Random ID Employee
    Get Pin Code                  ${id_employee}

Add work schedule                 [Tags]   all    employee
    [Documentation]               Thêm lịch làm việc cho nhân viên tại MH nhân viên
    Add Work Schedule
# case: xóa lịch làm việc nhân viên nếu nv có lịch làm việc
Delete work schedule              [Tags]   all    employee
    [Documentation]               Xóa lịch làm việc của nhân viên tại tab lịch làm việc của màn hình nhân viên
    Delete Work Schedule          ${id_work_schedule}

Delete Employee                   [Tags]   all    employee
    [Documentation]               Xóa 1 nhân viên
    Get Random ID Employee
    Delete Request KV             ${session}                          ${enp_employee}/${id_employee}    200

Delete multiple employee          [Tags]   all1    employee1
    [Documentation]               Xóa nhiều nhân viên cùng 1 lúc
    ${EmployeeId1}                Get Value In List KV                ${session}                      ${enp_employee}                 $.result.data[?(@.id)].id
    ${code_employee1}             Get Detail From Id KV               ${session}                      ${enp_employee}/${EmployeeId1}  $.result.code
    ${EmployeeId2}                Get Value In List KV                ${session}                      ${enp_employee}                 $.result.data[?(@.id)].id
    ${code_employee2}             Get Detail From Id KV               ${session}                      ${enp_employee}/${EmployeeId2}  $.result.code
    ${list}                       Create List                         ${EmployeeId1}                  ${EmployeeId2}
    ${data_mutiple_employee}      Format String Use [D0] [D1] [D2]    ${data_mutiple_employee}        ${list}
    ${resp}                       Delete Multiple Request KV          ${session}                      ${enp_multiple_employee}        ${data_mutiple_employee}    Xóa nhân viên thành công
