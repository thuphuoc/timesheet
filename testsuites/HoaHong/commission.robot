*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/commission.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
*** TestCases ***
Create commission               [Tags]                        all                       commission
    [Documentation]             Thêm mới hoa hồng
    Create Commission           170498                        ${random_str}             200

Create duplicate commission     [Tags]                        all                       commission
    [Documentation]             Thêm mới hoa hồng trùng tên
    ${name}                     Get Random Name Commission
    ${resp}                     Create Commission             123456                   ${name}                 400
    ${mess_err}                 Get Value From Json KV        ${resp}                  $.errors..message
    Should Be Equal             ${mess_err}                   Tên bảng hoa hồng đã tồn tại trên hệ thống

Create empty commission         [Tags]                        all                      commission
    [Documentation]             Thêm mới hoa hồng rỗng
    ${resp}                     Create Commission             123456                   \ \                    400
    ${mess_err}                 Get Value From Json KV        ${resp}       $.errors..message
    Should Be Equal             ${mess_err}                   Bạn chưa nhập Tên bảng hoa hồng

Update commission               [Tags]                        all                     commission
    [Documentation]             Cập nhật hoa hồng
    Update Commission

Delete commission               [Tags]                        all                     commission
    [Documentation]             Xóa hoa hồng
    Delete Commission
*** Keywords ***
