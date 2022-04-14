*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/1nhanvien/deduction.robot
Suite setup  Fill enviroment and get token     ${env}

*** Variables ***
${valueType}          1
${value}              12000
${type}               VND
${deductionRuleId}    1
${deductionTypeId}    2
# valueType: 1 theo VND, 2 theo %
# deductionRuleId: 1: đi muộn, 2: về sớm, 0: cố định , 1 tổng thu nhập
# deductionTypeId: 1: block, 2: số lần, nếu cố định thì chỗ này bằng 2 luôn
# Tùy theo các giá trị mà sẽ có giảm trừ tương ứng

*** TestCases ***
Create deduction early by VND             [Tags]    allretailer      allfnb          allbooking    deduction
    [Documentation]           Thêm mới giảm trừ về sớm theo số lần tính theo VND
    ${id}                     Random a Number    8
    ${resp}                   Create Deduction                ${id}       Về sớm ${random_str}     1      ${value}   ${type}      2      2      200

Create deduction late by block            [Tags]    allretailer      allfnb          allbooking    deduction
    [Documentation]           Thêm mới giảm trừ đi muộn theo block tính theo VND
    ${id}                     Random a Number    8
    ${resp}                   Create Deduction                ${id}       Đi muộn ${random_str}     1   ${value}     ${type}    1      1      200

Create deduction fix by VND             [Tags]    allretailer      allfnb          allbooking    deduction
    [Documentation]           Thêm mới giảm trừ cố định tính theo VND
    ${id}                     Random a Number    8
    ${resp}                   Create Deduction                ${id}      GT cố định ${random_str}    1      ${value}   ${type}   0     2      200

Create deduction by %             [Tags]    allretailer      allfnb          allbooking    deduction
    [Documentation]           Thêm mới giảm trừ  tính theo % tổng thu nhập
    ${id}                     Random a Number    8
    ${resp}                   Create Deduction                ${id}      GT Phần trăm ${random_str}    2    5   % Tổng thu nhập    1     2      200

Create duplicate deduction    [Tags]   allretailer      allfnb          allbooking    deduction
    [Documentation]           Thêm mới giảm trừ trùng tên
    ${name}                   Get Name Deduction
    ${id}                     Random a Number    8
    ${resp}                   Create Deduction              ${id}         ${name}          ${valueType}     ${value}   ${type}     ${deductionRuleId}      ${deductionTypeId}      400
    ${mess_err}               Get Value From Json KV        ${resp}       $.errors..message
    Should Be Equal           ${mess_err}                                 Giảm trừ đã tồn tại trên hệ thống

 Create empty deduction       [Tags]    allretailer      allfnb          allbooking    deduction
   [Documentation]            Thêm mới giảm trừ rỗng
   ${id}                      Random a Number    8
   ${resp}                    Create Deduction              ${id}         \ \               ${valueType}     ${value}   ${type}    ${deductionRuleId}      ${deductionTypeId}      400
   ${mess_err}                Get Value From Json KV        ${resp}       $.errors..message
   Should Be Equal            ${mess_err}                                 Tên giảm trừ không được để trống

Update deduction              [Tags]    allretailer      allfnb          allbooking    deduction
    [Documentation]           Cập nhật  giảm trừ
    Update Deduction          Update ${random_str}         ${valueType}   ${value}   ${type}     ${deductionRuleId}      ${deductionTypeId}

Delete deduction              [Tags]    allretailer      allfnb          allbooking    deduction
    [Documentation]           Xóa giảm trừ
    Delete deduction
*** Keywords ***
