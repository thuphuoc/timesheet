*** Settings ***
Resource  ../../core/Share/share.robot
Resource    shift.robot
*** Variables ***
${enp_timekeeping}               /clockings/get-clocking-multiple-branch-for-calendar?StartTime=[D0]&EndTime=[D1]&BranchIds=[D2]&ClockingStatusExtension=[D3]
${enp_add_work_schedule}         /timesheets/batchAddTimeSheetWhenCreateMultipleTimeSheet
${data_add_work_schedule}        {"TimeSheet":{"startDate":"[D0]","endDate":"[D1]","employeeId":[D2],"isRepeat":[D3],"hasEndDate":[D4],"repeatType":1,"repeatEachDay":1,"branchId":[D5],"saveOnHoliday":false,"timeSheetShifts":[{"shiftIds":"[D6]"}]}}
${data_timekeeping}              {"Clocking":{"id":[D0],"shiftId":[D1],"employeeId":[D2],"startTime":"[D3]","endTime":"[D4]"},"ClockingHistory":{"checkedInDate":"[D5]","checkedOutDate":"[D6]","timeKeepingType":1,"checkInDateType":2,"absenceType":[D7]},"LeaveOfAbsence":[D8]}
${enp_clocking}                  /clockings

*** Keywords ***
Get Id Clocking
    [Arguments]                 ${startTime}            ${endTime}       ${branch_id}           ${clocking_status}
    ${list_format}              Create List             ${startTime}     ${endTime}             ${branch_id}           ${clocking_status}
    ${enp_timekeeping}          Format String Use [D0] [D1] [D2]         ${enp_timekeeping}     ${list_format}
    ${id_clocking}              Get Value In List KV    ${session}       ${enp_timekeeping}     $..data[?(@.id)].id
    Return From Keyword         ${id_clocking}

Get startTime From Id Clocking
    [Arguments]                 ${id_clocking}
    ${startTime}                Get Value In List KV     ${session}       ${enp_clocking}/${id_clocking}       $.result.startTime
    Return From Keyword         ${startTime}

Get EndTime From Id Clocking
    [Arguments]                 ${id_clocking}
    ${endTime}                  Get Value In List KV     ${session}       ${enp_clocking}/${id_clocking}        $.result.endTime
    Return From Keyword         ${endTime}

Get ShiftId From Id Clocking
    [Arguments]                 ${id_clocking}
    ${id_shift}                 Get Value In List KV     ${session}       ${enp_clocking}/${id_clocking}       $.result.shiftId
    Return From Keyword         ${id_shift}

Get employeeId From Id Clocking
    [Arguments]                 ${id_clocking}
    ${id_employee}              Get Value In List KV     ${session}       ${enp_clocking}/${id_clocking}       $.result.employeeId
    Return From Keyword         ${id_employee}

Add Work-schedule Repeat Or Not_Repeate
    [Arguments]                 ${startDate}             ${endDate}       ${id_employee}                       ${hasEndDate}                ${is_repeat}        ${branchId}    ${id_shift}
    Format enp shift branch
    ${list_format}              Create List              ${startDate}      ${endDate}                          ${id_employee}               ${hasEndDate}       ${is_repeat}   ${branchId}    ${id_shift}
    ${data_add_work_schedule}   Format String Use [D0] [D1] [D2]           ${data_add_work_schedule}           ${list_format}
    ${resp}                     Post Request Json KV     ${session}        ${enp_add_work_schedule}            ${data_add_work_schedule}    200
    Return From Keyword         ${resp}

    # C??c tr???ng th??i clocking 1: ch??a v??o - ch??a ra,2: ???? v??o- ch??a ra; 3: ???? v??o- ???? ra, 3: c??ng l?? ch??a v??o- ???? ra; 4: Ngh??? c?? ph??p, ngh??? ko ph??p
Timekeeping for employees
    [Arguments]                 ${id_clocking}           ${id_shift}       ${id_employee}   ${startTime}      ${endTime}                    ${checkedInDate}   ${checkedOutDate}    ${absenceType}     ${LeaveOfAbsence}
    ${list_format}              Create List              ${id_clocking}    ${id_shift}      ${id_employee}    ${startTime}                  ${endTime}         ${checkedInDate}  ${checkedOutDate}   ${absenceType}     ${LeaveOfAbsence}
    ${data_timekeeping}         Format String Use [D0] [D1] [D2]           ${data_timekeeping}                ${list_format}
    ${resp}                     Update Request Json KV   ${session}        ${enp_clocking}/${id_clocking}     ${data_timekeeping}           200
