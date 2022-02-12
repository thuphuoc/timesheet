*** Settings ***
Resource  ../../core/Share/share.robot
Resource    shift.robot
*** Variables ***
${enp_timekeeping}        /clockings/get-clocking-multiple-branch-for-calendar?StartTime=[D0]&EndTime=[D1]&BranchIds=[D2]&ClockingStatusExtension=[D3]

${enp_add_work_schedule}         /timesheets/batchAddTimeSheetWhenCreateMultipleTimeSheet
${data_add_work_schedule}        {"TimeSheet":{"startDate":"[D0]","endDate":"[D1]","employeeId":[D2],"isRepeat":[D3],"hasEndDate":[D4],"repeatType":1,"repeatEachDay":1,"branchId":[D5],"saveOnHoliday":false,"timeSheetShifts":[{"shiftIds":"[D6]"}]}}
${data_timekeeping}              {"Clocking":{"id":[D0],"shiftId":[D1],"employeeId":[D2],"startTime":"[D3]","endTime":"[D4]"},"ClockingHistory":{"checkedInDate":"[D5]","checkedOutDate":"[D6]","timeKeepingType":1,"checkInDateType":2,"checkOutDateType":2}}
${enp_clocking}                  /clockings

*** Keywords ***
Get Id Clocking
    [Arguments]           ${startTime}            ${endTime}       ${branch_id}         ${clocking_status}
    ${list_format}        Create List             ${startTime}     ${endTime}           ${branch_id}           ${clocking_status}
    ${enp_timekeeping}    Format String Use [D0] [D1] [D2]         ${enp_timekeeping}   ${list_format}
    ${id_clocking}        Get value in list KV    ${session}      ${enp_timekeeping}    $..data[?(@.id)].id
    Return From Keyword   ${id_clocking}

Get startTime From Id Clocking
    [Arguments]          ${id_clocking}
    ${startTime}         Get value in list KV     ${session}       ${enp_clocking}/${id_clocking}       $.result.startTime
    Return From Keyword      ${startTime}

Get EndTime From Id Clocking
    [Arguments]         ${id_clocking}
    ${endTime}          Get value in list KV     ${session}       ${enp_clocking}/${id_clocking}        $.result.endTime
    Return From Keyword      ${endTime}

Get ShiftId From Id Clocking
    [Arguments]         ${id_clocking}
    ${id_shift}         Get value in list KV     ${session}       ${enp_clocking}/${id_clocking}       $.result.shiftId
    Return From Keyword      ${id_shift}

Get employeeId From Id Clocking
    [Arguments]         ${id_clocking}
    ${id_employee}      Get value in list KV     ${session}       ${enp_clocking}/${id_clocking}      $.result.employeeId
    Return From Keyword      ${id_employee}

Add Work-schedule Repeat Or Not_Repeate
    [Arguments]           ${startDate}      ${endDate}                  ${id_employee}               ${hasEndDate}    ${is_repeat}   ${branchId}    ${id_shift}
    Format enp shift branch
    ${list_format}        Create List             ${startDate}      ${endDate}                  ${id_employee}               ${hasEndDate}    ${is_repeat}   ${branchId}    ${id_shift}
    ${data_add_work_schedule}   Format String Use [D0] [D1] [D2]    ${data_add_work_schedule}   ${list_format}
    ${resp}               Post Request Json KV    ${session}        ${enp_add_work_schedule}    ${data_add_work_schedule}     200
    Return From Keyword    ${resp}

    # Các trạng thái clocking 1: chưa vào - chưa ra,2: đã vào- chưa ra; 3: đã vào- đã ra, 3: cũng là chưa vào- đã ra; 4: Nghỉ có phép, nghỉ ko phép
Timekeeping for employees
    [Arguments]           ${id_clocking}                    ${id_shift}       ${id_employee}   ${startTime}      ${endTime}              ${checkedInDate}   ${checkedOutDate}
    ${list_format}        Create List                       ${id_clocking}    ${id_shift}      ${id_employee}    ${startTime}            ${endTime}         ${checkedInDate}  ${checkedOutDate}
    ${data_timekeeping}   Format String Use [D0] [D1] [D2]                    ${data_timekeeping}                ${list_format}
    ${resp}               Update Request KV                 ${session}        ${enp_clocking}/${id_clocking}     ${data_timekeeping}     200
