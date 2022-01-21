*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/deduction.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token     ${env}

*** Variables ***
${valueType}          1
${deductionRuleId}    1
${deductionTypeId}    2
# valueType: 1 theo VND, 2 theo %
# deductionRuleId: 1: đi muộn, 2: về sớm, 0: cố định , 1 tổng thu nhập
# deductionTypeId: 1: block, 2: số lần, nếu cố định thì chỗ này bằng 2 luôn
# Tùy theo các giá trị mà sẽ có giảm trừ tương ứng
*** TestCases ***
Create deduction early by VND             [Tags]   all    deduction
    [Documentation]           Thêm mới giảm trừ về sớm theo số lần tính theo VND
    ${id}                     Random a Number    8
    ${resp}                   Create Deduction                ${id}       Về sớm ${random_str}     1         2      2      200

Create deduction late by block            [Tags]   all    deduction
    [Documentation]           Thêm mới giảm trừ đi muộn theo block tính theo VND
    ${id}                     Random a Number    8
    ${resp}                   Create Deduction                ${id}       Đi muộn ${random_str}     1       1      1      200

Create deduction fix by VND             [Tags]   all    deduction
    [Documentation]           Thêm mới giảm trừ cố định tính theo VND
    ${id}                     Random a Number    8
    ${resp}                   Create Deduction                ${id}      GT cố định ${random_str}    1        0     2      200

Create deduction by %             [Tags]   all    deduction
    [Documentation]           Thêm mới giảm trừ  tính theo % tổng thu nhập
    ${id}                     Random a Number    8
    ${resp}                   Create Deduction                ${id}      GT Phần trăm ${random_str}    2        1     2      200

Create duplicate deduction    [Tags]  all    deduction
    [Documentation]           Thêm mới giảm trừ trùng tên
    ${name}                   Get Name Deduction
    ${id}                     Random a Number    8
    ${resp}                   Create Deduction              ${id}         ${name}          ${valueType}         ${deductionRuleId}      ${deductionTypeId}      400
    ${mess_err}               Get Value From Json KV        ${resp}       $.errors..message
    Should Be Equal           ${mess_err}                                 Giảm trừ đã tồn tại trên hệ thống

 Create empty deduction       [Tags]   all    deduction
   [Documentation]            Thêm mới giảm trừ rỗng
   ${id}                      Random a Number    8
   ${resp}                    Create Deduction              ${id}         \ \               ${valueType}         ${deductionRuleId}      ${deductionTypeId}      400
   ${mess_err}                Get Value From Json KV        ${resp}       $.errors..message
   Should Be Equal            ${mess_err}                                 Tên giảm trừ không được để trống

Update deduction              [Tags]   all    deduction
    [Documentation]           Cập nhật  giảm trừ
    Update Deduction          Update ${random_str}         ${valueType}       ${deductionRuleId}      ${deductionTypeId}

Delete deduction              [Tags]   all    deduction
    [Documentation]           Xóa giảm trừ
    Delete deduction
*** Keywords ***
