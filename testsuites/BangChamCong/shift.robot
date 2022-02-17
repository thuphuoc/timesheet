*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../../core/Share/enviroment.robot
Resource  ../../core/Share/share.robot
Resource   ../../core/Share/share_random.robot
Resource   ../../core/bangchamcong/shift.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
*** TestCases ***

Create shift                    [Tags]   all    shift
    [Documentation]             Thêm mới ca làm việc
    ${resp}                     Create Shift        ${random_number}    ${random_str}       ${branchId}             200
    Get Message Expected        ${resp}             $.message           Tạo ca thành công

Create duplicate shift          [Tags]   all    shift
    [Documentation]             Thêm mới ca làm việc trùng  tên
    Format enp shift branch
    ${name}                     Get Value In List KV                    ${session}          ${enp_shift_branch}     $.result..name
    
Create empty shift              [Tags]   all    shift
    [Documentation]             Thêm mới ca làm việc rỗng
    Format enp shift branch
    ${resp}                    Create shift        ${random_number}    \ \                 ${branchId}             400
    Get Message Expected       ${resp}             $.errors..message                       Bạn chưa nhập tên ca

Update shift                    [Tags]   all    shift
    [Documentation]             Cập nhật ca làm việc
    Format enp shift branch
    ${resp}                     Update Shift
    Get Message Expected        ${resp}             $.message                              Cập nhật ca thành công
# Xóa ca làm việc ko có chi tiết chấm công
Delete shift                    [Tags]   all    shift
    [Documentation]             Xóa ca làm việc
    Format enp shift branch
    Delete Shift

*** Keywords ***
Check duplicate shift
    [Arguments]                 ${name}
    ${resp}                     Create shift        ${random_number}    ${name}             ${branchId}             400
    Get Message Expected        ${resp}             $.errors..message   Tên ca đã tồn tại
