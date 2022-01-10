*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token    ${env}

*** Variables ***
${data_shift}   {"shift":{"id":[D0],"name":"[D1]","from":420,"to":660,"isActive":true,"branchId":[D2],"checkInBefore":240,"checkOutAfter":840}}
${enp_shift}    /shifts

*** TestCases ***
# khi tạo ca làm việc thì response trả về mess
Create shift    [Tags]    shift
    ${list_format}    Create List   170498  ${random_str}    ${branchId}
    ${data_shift}     Format String Use [D0] [D1] [D2]       ${data_shift}    ${list_format}
    ${resp}           Post Request Json KV     ${session}    ${enp_shift}     ${data_shift}    200
    ${mess_expected}  Get Value From Json KV   ${resp.json()}    $.message
    Should Be Equal   ${mess_expected}    Tạo ca thành công
Update shift    [Tags]    shift
    ${id_shift}       Get value in list KV    ${enp_shift}     $.result.data..id
    ${list_format}    Create List   ${id_shift}    ${random_str}    ${branchId}
    ${data_shift}     Format String Use [D0] [D1] [D2]         ${data_shift}    ${list_format}
    ${resp}           Update Request KV    ${session}     ${enp_shift}/${id_shift}    ${data_shift}    200
    ${mess_expected}  Get Value From Json KV   ${resp.json()}    $.message
    Should Be Equal   ${mess_expected}     Cập nhật ca thành công
# Xóa ca làm việc ko có chi tiết chấm công
Delete shift    [Tags]    shiftf
    ${id_shift}           Get value in list KV    ${enp_shift}    $.result.data..id
    Delete Request KV     ${session}    ${enp_shift}/${id_shift}    200

*** Keywords ***
