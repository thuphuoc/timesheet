*** Settings ***
Resource   ../../core/share/enviroment.robot
Resource  ../../core/share/share.robot
Resource   ../../core/share/share_random.robot
Resource   ../../core/bangchamcong/shift.robot
Resource   ../../core/bangchamcong/addwork_schedule.robot
Resource   ../../core/nhanvien/employee.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
${enp_add_work_schedule}         /timesheets/batchAddTimeSheetWhenCreateMultipleTimeSheet
${data_add_work_schedule}        {"TimeSheet":{"startDate":"[D0]","endDate":"[D1]","employeeId":[D2],"isRepeat":[D3],"hasEndDate":[D4],"repeatType":1,"repeatEachDay":1,"branchId":[D5],"saveOnHoliday":false,"timeSheetShifts":[{"shiftIds":"[D6]"}]}}
${data_timekeeping}              {"Clocking":{"id":[D0],"shiftId":[D1],"employeeId":[D2],"startTime":"[D3]","endTime":"[D4]"},"ClockingHistory":{"checkedInDate":"2022-01-06T00:00:00.000Z","checkedOutDate":"2022-01-06T05:26:00.000Z","timeKeepingType":1,"checkInDateType":2,"checkOutDateType":2}}
${enp_clocking}                  /clockings
${startDate}                     2022-04-05
${endDate}                       2022-05-10
*** TestCases ***
Add work-schedule repeat has repeat     [Tags]        all       addschedule
      [Documentation]       Đặt lịch làm việc có ngày kết thúc tại màn hình chấm công
      Format enp shift branch
      ${id_employee}        Get Random ID Employee
      ${id_shift}           Get RanDom ID Shift And Get Name From ID
      ${list_format}        Create List             ${startDate}      ${endDate}                  ${id_employee}               true  true   ${branchId}    ${id_shift}
      ${data_add_work_schedule}   Format String Use [D0] [D1] [D2]    ${data_add_work_schedule}   ${list_format}
      ${resp}               Post Request Json KV    ${session}        ${enp_add_work_schedule}    ${data_add_work_schedule}     200
      ${id_work_schedule}   Get Value From Json KV    ${resp}         $.result[?(@.id)].id
      Set Suite Variable    ${id_work_schedule}    ${id_work_schedule}
      Delete work schedule      ${id_work_schedule}

Add work-schedule repeat has NOT repeat     [Tags]        all       addschedule
      [Documentation]       Đặt lịch làm việc Không giới hạn tại màn hình chấm công
      Format enp shift branch
      ${id_employee}        Get Random ID Employee
      ${id_shift}           Get RanDom ID Shift And Get Name From ID
      ${list_format}        Create List             ${startDate}      ${endDate}                  ${id_employee}               true  false   ${branchId}    ${id_shift}
      ${data_add_work_schedule}   Format String Use [D0] [D1] [D2]    ${data_add_work_schedule}   ${list_format}
      ${resp}               Post Request Json KV    ${session}        ${enp_add_work_schedule}    ${data_add_work_schedule}     200
      ${id_work_schedule}   Get Value From Json KV    ${resp}         $.result[?(@.id)].id
      Set Suite Variable    ${id_work_schedule}    ${id_work_schedule}
      Delete work schedule      ${id_work_schedule}

# Các trạng thái clocking 1: chưa vào - chưa ra,2: đã vào- chưa ra; 3: đã vào- đã ra, 3: cũng là chưa vào- đã ra; 4: Nghỉ có phép, nghỉ ko phép
Timekeeping for employees   [Tags]        all       clocking
      [Documentation]       Chấm công cho nhân viên
      ${id_clocking}        Get Id Clocking                   2022-01-01        2022-02-01                        ${branchId}             1
      ${id_shift}           Get ShiftId From Id Clocking      ${id_clocking}
      ${name_shift}         Get value in list KV              ${session}        ${enp_shift}/${id_shift}           $..name
      ${startTime}          Get StartTime From Id Clocking    ${id_clocking}
      ${endTime}            Get EndTime From Id Clocking      ${id_clocking}
      ${id_employee}        Get employeeId From Id Clocking   ${id_clocking}
      ${name_employee}      Get value in list KV              ${session}        ${enp_employee}/${id_employee}     $..name
      ${list_format}        Create List                       ${id_clocking}    ${id_shift}      ${id_employee}    ${startTime}            ${endTime}
      ${data_timekeeping}   Format String Use [D0] [D1] [D2]                    ${data_timekeeping}                ${list_format}
      ${resp}               Update Request KV                 ${session}        ${enp_clocking}/${id_clocking}     ${data_timekeeping}     200

*** Keywords ***
