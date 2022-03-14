*** Settings ***
Resource   ../../core/Share/enviroment.robot
Resource  ../../core/Share/share.robot
Resource   ../../core/Share/share_random.robot
Resource   ../../core/bangchamcong/shift.robot
Resource   ../../core/bangchamcong/addwork_schedule.robot
Resource   ../../core/NhanVien/employee.robot
Suite setup  Fill enviroment and get token    ${env}
Suite Teardown  Test After     ${id_work_schedule}      ${id_employee}
*** Variables ***
${startDate}                     2022-02-02
${endDate}                       2022-04-30
${checkedInDate}                 2022-02-06T00:26:00.000Z
${checkedOutDate}                2022-02-06T07:15:00.000Z
${absenceType}                   null
${LeaveOfAbsence}                false
# LeaveOfAbsence: nghỉ có phép hoặc ko phép thì biến này bằng true còn lại là false
# checkOutDateType               2: nghỉ ko phép, 1: nghỉ có phép   null: các trạng thái còn lại
*** TestCases ***
Add work-schedule repeat has endDate     [Tags]        allretailer      allfnb          allbooking      addschedule
      [Documentation]       Đặt lịch làm việc có ngày kết thúc tại màn hình chấm công
      Format enp shift branch
      ${random_number}      Random a Number    6
      ${id_employee}        Create And Get ID Employee                 1235698           NV${random_number}            ${random_str}         ${branchId}           ${branchId}    100000    300    300
      ${id_shift}           Get RanDom ID Shift And Get Name From ID
      ${resp}               Add Work-schedule Repeat Or Not_Repeate    ${startDate}      ${endDate}       ${id_employee}        true        true   ${branchId}    ${id_shift}
      ${id_work_schedule}   Get Value From Json KV                     ${resp}           $.result[?(@.id)].id
      Set Suite Variable    ${id_employee}                             ${id_employee}
      Test After            ${id_work_schedule}                        ${id_employee}

Add work-schedule repeat has NOT endDate     [Tags]        allretailer      allfnb          allbooking       addschedule
      [Documentation]       Đặt lịch làm việc Không giới hạn tại màn hình chấm công
      Format enp shift branch
      ${random_number}      Random a Number    6
      ${id_employee}        Create And Get ID Employee    1235698                   NV${random_number}            ${random_str}         ${branchId}           ${branchId}    100000    300    300
      ${id_shift}           Get RanDom ID Shift And Get Name From ID
      ${resp}               Add Work-schedule Repeat Or Not_Repeate    ${startDate}      ${endDate}       ${id_employee}        true        false   ${branchId}    ${id_shift}
      ${id_work_schedule}   Get Value From Json KV    ${resp}          $.result[?(@.id)].id
      Set Suite Variable    ${id_work_schedule}                        ${id_work_schedule}

      # Các trạng thái clocking 1: chưa vào - chưa ra,2: đã vào- chưa ra; 3: đã vào- đã ra, 3: cũng là chưa vào- đã ra; 4: Nghỉ có phép, nghỉ ko phép
Timekeeping check IN- OUT for employees   [Tags]     allretailer      allfnb          allbooking      addschedule      clocking
      [Documentation]       Chấm công VÀO và RA cho nhân viên
      ${id_clocking}        Get Id Clocking                   2022-02-02        2022-04-30                        ${branchId}             1
      ${id_shift}           Get ShiftId From Id Clocking      ${id_clocking}
      ${name_shift}         Get Value In List KV              ${session}        ${enp_shift}/${id_shift}           $..name
      ${startTime}          Get StartTime From Id Clocking    ${id_clocking}
      ${endTime}            Get EndTime From Id Clocking      ${id_clocking}
      ${id_employee}        Get employeeId From Id Clocking   ${id_clocking}
      ${name_employee}      Get Value In List KV              ${session}        ${enp_employee}/${id_employee}     $..name
      Timekeeping for employees     ${id_clocking}            ${id_shift}       ${id_employee}    ${startTime}     ${endTime}        ${startTime}   ${endTime}   ${absenceType}     ${LeaveOfAbsence}

Timekeeping check IN for employees   [Tags]        allretailer      allfnb          allbooking        addschedule         clocking
      [Documentation]       Chỉ chấm công VÀO cho nhân viên
      ${id_clocking}        Get Id Clocking                   2022-02-02        2022-04-30                        ${branchId}             1
      ${id_shift}           Get ShiftId From Id Clocking      ${id_clocking}
      ${name_shift}         Get Value In List KV              ${session}        ${enp_shift}/${id_shift}           $..name
      ${startTime}          Get StartTime From Id Clocking    ${id_clocking}
      ${endTime}            Get EndTime From Id Clocking      ${id_clocking}
      ${id_employee}        Get employeeId From Id Clocking   ${id_clocking}
      ${name_employee}      Get Value In List KV              ${session}        ${enp_employee}/${id_employee}     $..name
      Timekeeping for employees     ${id_clocking}            ${id_shift}       ${id_employee}    ${startTime}     ${endTime}     ${checkedInDate}   null    ${absenceType}     ${LeaveOfAbsence}

Timekeeping check OUT for employees   [Tags]        allretailer      allfnb          allbooking       addschedule       clocking
      [Documentation]       Chỉ chấm công RA cho nhân viên
      ${id_clocking}        Get Id Clocking                   2022-02-02        2022-04-30                        ${branchId}             1
      ${id_shift}           Get ShiftId From Id Clocking      ${id_clocking}
      ${name_shift}         Get Value In List KV              ${session}        ${enp_shift}/${id_shift}           $..name
      ${startTime}          Get StartTime From Id Clocking    ${id_clocking}
      ${endTime}            Get EndTime From Id Clocking      ${id_clocking}
      ${id_employee}        Get employeeId From Id Clocking   ${id_clocking}
      ${name_employee}      Get Value In List KV              ${session}        ${enp_employee}/${id_employee}     $..name
      Timekeeping for employees     ${id_clocking}            ${id_shift}       ${id_employee}    ${startTime}     ${endTime}     null   ${endTime}    ${absenceType}     ${LeaveOfAbsence}

Timekeeping Unpaid for employees   [Tags]     allretailer      allfnb          allbooking      addschedule      clocking
    [Documentation]       Nhân viên NGHỈ KO phép
    ${id_clocking}        Get Id Clocking                   2022-02-02        2022-04-30                        ${branchId}             1
    ${id_shift}           Get ShiftId From Id Clocking      ${id_clocking}
    ${name_shift}         Get Value In List KV              ${session}        ${enp_shift}/${id_shift}           $..name
    ${startTime}          Get StartTime From Id Clocking    ${id_clocking}
    ${endTime}            Get EndTime From Id Clocking      ${id_clocking}
    ${id_employee}        Get employeeId From Id Clocking   ${id_clocking}
    ${name_employee}      Get Value In List KV              ${session}        ${enp_employee}/${id_employee}     $..name
    Timekeeping for employees     ${id_clocking}            ${id_shift}       ${id_employee}    ${startTime}     ${endTime}        null   null   2      true

Timekeeping Paid for employees   [Tags]     allretailer      allfnb          allbooking      addschedule      clocking
      [Documentation]       Nhân viên Nghỉ có phép
      ${id_clocking}        Get Id Clocking                   2022-02-02        2022-04-30                        ${branchId}             1
      ${id_shift}           Get ShiftId From Id Clocking      ${id_clocking}
      ${name_shift}         Get Value In List KV              ${session}        ${enp_shift}/${id_shift}           $..name
      ${startTime}          Get StartTime From Id Clocking    ${id_clocking}
      ${endTime}            Get EndTime From Id Clocking      ${id_clocking}
      ${id_employee}        Get employeeId From Id Clocking   ${id_clocking}
      ${name_employee}      Get Value In List KV              ${session}        ${enp_employee}/${id_employee}     $..name
      Timekeeping for employees     ${id_clocking}            ${id_shift}       ${id_employee}    ${startTime}     ${endTime}        null   null   1     true
*** Keywords ***
Test After
      [Arguments]               ${id_work_schedule}           ${id_employee}
      Delete work schedule      ${id_work_schedule}
      Delete Employee           ${id_employee}
