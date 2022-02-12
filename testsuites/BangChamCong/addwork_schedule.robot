*** Settings ***
Resource   ../../core/share/enviroment.robot
Resource  ../../core/share/share.robot
Resource   ../../core/share/share_random.robot
Resource   ../../core/bangchamcong/shift.robot
Resource   ../../core/bangchamcong/addwork_schedule.robot
Resource   ../../core/nhanvien/employee.robot
Suite setup  Fill enviroment and get token    ${env}
Suite Teardown  Test After     ${id_work_schedule}
*** Variables ***
${startDate}                     2022-02-02
${endDate}                       2022-04-30
${checkedInDate}                 2022-02-06T00:26:00.000Z
${checkedOutDate}                2022-02-06T05:15:00.000Z
*** TestCases ***
Add work-schedule repeat has endDate     [Tags]        all       addschedule
      [Documentation]       Đặt lịch làm việc có ngày kết thúc tại màn hình chấm công
      Format enp shift branch
      ${id_employee}        Get Random ID Employee
      ${id_shift}           Get RanDom ID Shift And Get Name From ID
      ${resp}               Add Work-schedule Repeat Or Not_Repeate    ${startDate}      ${endDate}       ${id_employee}        true        true   ${branchId}    ${id_shift}
      ${id_work_schedule}   Get Value From Json KV    ${resp}         $.result[?(@.id)].id
      Test After            ${id_work_schedule}

Add work-schedule repeat has NOT endDate     [Tags]        all       addschedule
      [Documentation]       Đặt lịch làm việc Không giới hạn tại màn hình chấm công
      Format enp shift branch
      ${id_employee}        Get Random ID Employee
      ${id_shift}           Get RanDom ID Shift And Get Name From ID
      ${resp}               Add Work-schedule Repeat Or Not_Repeate    ${startDate}      ${endDate}       ${id_employee}        true        false   ${branchId}    ${id_shift}
      ${id_work_schedule}   Get Value From Json KV    ${resp}         $.result[?(@.id)].id
      Set Suite Variable    ${id_work_schedule}    ${id_work_schedule}

      # Các trạng thái clocking 1: chưa vào - chưa ra,2: đã vào- chưa ra; 3: đã vào- đã ra, 3: cũng là chưa vào- đã ra; 4: Nghỉ có phép, nghỉ ko phép
Timekeeping check IN- OUT for employees   [Tags]        all      addschedule   clocking
      [Documentation]       Chấm công VÀO và RA cho nhân viên
      ${id_clocking}        Get Id Clocking                   2022-02-02        2022-04-30                        ${branchId}             1
      ${id_shift}           Get ShiftId From Id Clocking      ${id_clocking}
      ${name_shift}         Get value in list KV              ${session}        ${enp_shift}/${id_shift}           $..name
      ${startTime}          Get StartTime From Id Clocking    ${id_clocking}
      ${endTime}            Get EndTime From Id Clocking      ${id_clocking}
      ${id_employee}        Get employeeId From Id Clocking   ${id_clocking}
      ${name_employee}      Get value in list KV              ${session}        ${enp_employee}/${id_employee}     $..name
      Timekeeping for employees     ${id_clocking}            ${id_shift}       ${id_employee}    ${startTime}     ${endTime}        ${checkedInDate}   ${checkedOutDate}

Timekeeping check IN for employees   [Tags]        all      addschedule   clocking
      [Documentation]       Chỉ chấm công VÀO cho nhân viên
      ${id_clocking}        Get Id Clocking                   2022-02-02        2022-04-30                        ${branchId}             1
      ${id_shift}           Get ShiftId From Id Clocking      ${id_clocking}
      ${name_shift}         Get value in list KV              ${session}        ${enp_shift}/${id_shift}           $..name
      ${startTime}          Get StartTime From Id Clocking    ${id_clocking}
      ${endTime}            Get EndTime From Id Clocking      ${id_clocking}
      ${id_employee}        Get employeeId From Id Clocking   ${id_clocking}
      ${name_employee}      Get value in list KV              ${session}        ${enp_employee}/${id_employee}     $..name
      Timekeeping for employees     ${id_clocking}            ${id_shift}       ${id_employee}    ${startTime}     ${endTime}     ${checkedInDate}   \ \

Timekeeping check OUT for employees   [Tags]        all      addschedule   clocking
      [Documentation]       Chỉ chấm công RA cho nhân viên
      ${id_clocking}        Get Id Clocking                   2022-02-02        2022-04-30                        ${branchId}             1
      ${id_shift}           Get ShiftId From Id Clocking      ${id_clocking}
      ${name_shift}         Get value in list KV              ${session}        ${enp_shift}/${id_shift}           $..name
      ${startTime}          Get StartTime From Id Clocking    ${id_clocking}
      ${endTime}            Get EndTime From Id Clocking      ${id_clocking}
      ${id_employee}        Get employeeId From Id Clocking   ${id_clocking}
      ${name_employee}      Get value in list KV              ${session}        ${enp_employee}/${id_employee}     $..name
      Timekeeping for employees     ${id_clocking}            ${id_shift}       ${id_employee}    ${startTime}     ${endTime}     \ \  ${checkedOutDate}


*** Keywords ***
Test After
      [Arguments]               ${id_work_schedule}
      Delete work schedule      ${id_work_schedule}
