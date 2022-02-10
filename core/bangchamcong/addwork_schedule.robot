*** Settings ***
Resource  ../../core/share/share.robot
*** Variables ***
${enp_timekeeping}        /clockings/get-clocking-multiple-branch-for-calendar?StartTime=[D0]&EndTime=[D1]&BranchIds=[D2]&ClockingStatusExtension=[D3]

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
