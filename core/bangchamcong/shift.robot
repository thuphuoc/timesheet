*** Settings ***
Resource  ../../core/Share/share.robot
*** Variables ***
${data_shift}         {"shift":{"id":[D0],"name":"[D1]","from":420,"to":660,"isActive":true,"branchId":[D2],"checkInBefore":240,"checkOutAfter":840}}
${enp_shift}          /shifts
${enp_shift_branch}   /shifts/multiple-branch/orderby-from-to?BranchIds=[D0]&ShiftIds=

*** Keywords ***
Format enp shift branch
    ${list_format}         Create List                            ${branchId}
    ${enp_shift_branch}    Format String Use [D0] [D1] [D2]       ${enp_shift_branch}                ${list_format}
    Set Global Variable    ${enp_shift_branch}                    ${enp_shift_branch}

Get RanDom ID Shift And Get Name From ID
    ${id_shift}           Get Value In List KV      ${session}    ${enp_shift_branch}                $..id
    ${name_shift}         Get Detail From Id KV     ${session}    ${enp_shift}/${id_shift}           $..name
    Return From Keyword   ${id_shift}

Create Shift
    [Arguments]            ${id}                                  ${name}                            ${branch_id}       ${expected_statusCode}
    ${list_format}         Create List                            ${id}                              ${name}            ${branch_id}
    ${data_shift}          Format String Use [D0] [D1] [D2]       ${data_shift}                      ${list_format}
    ${resp}                Post Request Json KV                   ${session}                         ${enp_shift}       ${data_shift}          ${expected_statusCode}
    Log                    ${resp}
    Return From Keyword    ${resp}

Update Shift
    ${id_shift}            Get Value In List KV                 ${session}                          ${enp_shift_branch}                       $.result..id
    ${name_shift}          Get Detail From Id KV                ${session}                          ${enp_shift}/${id_shift}                  $.result.name
    ${list_format}         Create List   ${id_shift}            Update${random_str}                 ${branchId}
    ${data_shift}          Format String Use [D0] [D1] [D2]     ${data_shift}                       ${list_format}
    ${resp}                Update Request Json KV               ${session}                          ${enp_shift}/${id_shift}                  ${data_shift}           200
    Return From Keyword    ${resp}

Delete Shift
    ${id_shift}            Get Value In List KV                 ${session}                          ${enp_shift_branch}                       $.result..id
    ${name_shift}          Get Detail From Id KV                ${session}                          ${enp_shift}/${id_shift}                  $.result.name
    ${resp}                Delete Request                       ${session}                          ${enp_shift}/${id_shift}
    Convert To String      ${resp.status_code}
    Run Keyword If        '${resp.status_code}'=='200'          Log                                 Đã xóa thành công
    ...         ELSE       Delete Request Shift                 ${resp.json()}

Delete Request Shift
    [Arguments]            ${resp}
    ${mess_expected}       Get Value From Json KV               ${resp}                            $..errors..message
    Log                    ${mess_expected}
