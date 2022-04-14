***Settings***
Library     JSONLibrary
Library     RequestsLibrary
Library     Collections
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/2bangchamcong/shift.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/1nhanvien/employee.robot
Suite setup     Fill enviroment and get token    ${env}
*** Test Cases ***
Check total employee              [Tags]    allretailer      allfnb          allbooking    employee
    ${resp}                       Check Total Employee
    Run Keyword If                ${resp}==400              Delete Multiple Employee
    ...                           ELSE                      Log             Gian hàng vẫn có thể thêm mới nhân viên

Create employee                   [Tags]    allretailer      allfnb          allbooking    employee
    [Documentation]               Tạo mới nhân viên  và thiết lập lương ko có mẫu lương
    ${resp}                       Create Employee     1235698               NV${random_number}            ${random_str}         ${branchId}           ${branchId}    100000    200    300

Create duplicate employee         [Tags]    allretailer      allfnb          allbooking    employee
    [Documentation]               Tạo mới nhân viên trùng mã nhân viên
    ${resp}                       Check Total Employee
    Run Keyword If                ${resp}==400              Delete Multiple Employee
    ...                           ELSE                      Log             Gian hàng vẫn có thể thêm mới nhân viên
    Create Duplicate Employee

Create empty employee             [Tags]    allretailer      allfnb          allbooking    employee
    [Documentation]               Tạo mới nhân viên rỗng
    ${resp}                       Check Total Employee
    Run Keyword If                ${resp}==400              Delete Multiple Employee
    ...                           ELSE                      Log             Gian hàng vẫn có thể thêm mới nhân viên
    Create Empty Employee

Update employee                   [Tags]    allretailer      allfnb          allbooking    employee
    [Documentation]               Cập nhật nhân viên
    ${id_employee}                Get Random ID Employee
    Update Employee               ${id_employee}

Get pin code                      [Tags]    allretailer      allfnb          allbooking    employee
    [Documentation]               Lấy mã xác nhận cho chấm công gps
    ${id_employee}                Get Random ID Employee
    Get Pin Code                  ${id_employee}

Add work schedule                 [Tags]    allretailer      allfnb          allbooking    employee  
    [Documentation]               Thêm lịch làm việc cho nhân viên tại MH nhân viên
    ${id_work_schedule}           Add Work Schedule

# case: xóa lịch làm việc nhân viên nếu nv có lịch làm việc
Delete work schedule              [Tags]    allretailer      allfnb          allbooking    employee
    [Documentation]               Xóa lịch làm việc của nhân viên tại tab lịch làm việc của màn hình nhân viên
    Delete Work Schedule          ${id_work_schedule}

Delete Employee                   [Tags]    allretailer      allfnb          allbooking    employee
    [Documentation]               Xóa 1 nhân viên
    Get Random ID Employee
    Delete Request KV             ${session}                          ${enp_employee}/${id_employee}    200

***Keywords***
