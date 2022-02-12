*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../../core/share/enviroment.robot
Resource  ../../core/share/share.robot
Resource   ../../core/share/share_random.robot
Resource   ../../core/bangchamcong/shift.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
*** TestCases ***

Create shift               [Tags]   all    shift
    [Documentation]        Thêm mới ca làm việc
    ${resp}                Create shift    ${random_number}    ${random_str}    ${branchId}      200
    Get mess_expected      ${resp}         $.message           Tạo ca thành công

Create duplicate shift     [Tags]   all    shift
    [Documentation]        Thêm mới ca làm việc trùng  tên
    Format enp shift branch
    ${name}                Get value in list KV                ${session}       ${enp_shift_branch}                $.result..name
    ${resp}                Create shift    ${random_number}    ${name}          ${branchId}      400
    Get mess_expected      ${resp}         $.errors..message   Tên ca đã tồn tại

Create empty shift         [Tags]   all    shift
    [Documentation]        Thêm mới ca làm việc rỗng
    Format enp shift branch
     ${resp}               Create shift     ${random_number}    \ \     ${branchId}     400
    Get mess_expected      ${resp}          $.errors..message   Bạn chưa nhập tên ca

Update shift               [Tags]   all    shift
    [Documentation]        Cập nhật ca làm việc
    Format enp shift branch
    ${resp}                Update shift
    Get mess_expected      ${resp}          $.message          Cập nhật ca thành công
# Xóa ca làm việc ko có chi tiết chấm công
Delete shift               [Tags]   all    shift
    [Documentation]        Xóa ca làm việc
    Format enp shift branch
    Delete Shift
