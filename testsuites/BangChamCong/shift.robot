*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token    ${env}

*** Variables ***
${data_shift}         {"shift":{"id":[D0],"name":"[D1]","from":420,"to":660,"isActive":true,"branchId":[D2],"checkInBefore":240,"checkOutAfter":840}}
${enp_shift}          /shifts
${enp_shift_branch}   /shifts/multiple-branch/orderby-from-to?BranchIds=[D0]&ShiftIds=

*** TestCases ***

Format enp shift branch    [Tags]   all    shift
    ${list_format}         Create List                            ${branchId}
    ${enp_shift_branch}    Format String Use [D0] [D1] [D2]       ${enp_shift_branch}                ${list_format}
    Set Global Variable    ${enp_shift_branch}                    ${enp_shift_branch}

Create shift               [Tags]   all    shift
    [Documentation]        Thêm mới ca làm việc
    ${list_format}         Create List                            170498  ${random_str}              ${branchId}
    ${data_shift}          Format String Use [D0] [D1] [D2]       ${data_shift}                      ${list_format}
    ${resp}                Post Request Json KV                   ${session}                         ${enp_shift}              ${data_shift}            200
    ${mess_expected}       Get Value From Json KV                 ${resp}                            $.message
    Should Be Equal        ${mess_expected}                       Tạo ca thành công

Create duplicate shift     [Tags]   all    shift
    [Documentation]        Thêm mới ca làm việc trùng  tên
    ${name}                Get value in list KV                  ${session}                         ${enp_shift_branch}                $.result..name
    ${list_format}         Create List   170498                  ${name}                            ${branchId}
    ${data_shift}          Format String Use [D0] [D1] [D2]      ${data_shift}                      ${list_format}
    ${resp}                Create value duplicate_empty          ${session}                         ${enp_shift}                       ${data_shift}               Tên ca đã tồn tại

Create empty shift         [Tags]   all    shift
    [Documentation]        Thêm mới ca làm việc rỗng
    ${list_format}         Create List   170498                  \ \                                ${branchId}
    ${data_shift}          Format String Use [D0] [D1] [D2]      ${data_shift}                      ${list_format}
    ${resp}                Create value duplicate_empty          ${session}                         ${enp_shift}                       ${data_shift}               Bạn chưa nhập tên ca

Update shift               [Tags]   all    shift
    [Documentation]        Cập nhật ca làm việc
    ${id_shift}            Get value in list KV                 ${session}                          ${enp_shift_branch}                 $.result..id
    ${list_format}         Create List   ${id_shift}            Update${random_str}                 ${branchId}
    ${data_shift}          Format String Use [D0] [D1] [D2]     ${data_shift}                       ${list_format}
    ${resp}                Update Request KV                    ${session}                          ${enp_shift}/${id_shift}    ${data_shift}             200
    ${mess_expected}       Get Value From Json KV               ${resp}                             $.message
    Should Be Equal        ${mess_expected}                     Cập nhật ca thành công
# Xóa ca làm việc ko có chi tiết chấm công
Delete shift               [Tags]   all    shift
    [Documentation]        Xóa ca làm việc
    ${id_shift}            Get value in list KV                 ${session}                          ${enp_shift_branch}                 $.result..id
    ${name_shift}          Get detail from id KV                ${session}                          ${enp_shift}/${id_shift}            $.result.name
    ${resp}                Delete Request                       ${session}                          ${enp_shift}/${id_shift}
    Convert To String      ${resp.status_code}
    Run Keyword If        '${resp.status_code}'=='200'         Log   Đã xóa thành công
    ...         ELSE       Delete Request Shift                ${resp.json()}
*** Keywords ***
Delete Request Shift
    [Arguments]            ${resp}
    ${mess_expected}       Get Value From Json KV               ${resp}                           $..errors..message
    Log                    ${mess_expected}
