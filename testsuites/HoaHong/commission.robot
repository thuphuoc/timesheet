*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../../core/share/enviroment.robot
Resource  ../../core/share/share.robot
Resource   ../../core/share/share_random.robot
Resource   ../../core/hoahong/commission.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
*** TestCases ***
Create commission               [Tags]                        all                       commission
    [Documentation]             Thêm mới hoa hồng
    ${resp}                     Create Commission           170498                        ${random_str}             200
    ${id_commmission}           Get Value From Json           ${resp}     $..id
    ${name_commmission}         Get Value From Json           ${resp}     $..name
    Set Suite Variable          ${id_commmission}           ${id_commmission}
    Set Suite Variable          ${name_commmission}      ${name_commmission}

Add Category Of Product Into Commission    [Tags]                        all                       commission
    [Documentation]             Thêm nhóm hàng hóa vào bảng hoa hồng
    Log                         ${name_commmission}    
    ${id_category}              Get Id Category Product
    ${resp}                     Add Category Of Product Into Commission      ${id_commmission}    ${id_category}

Create duplicate commission     [Tags]                        all                       commission
    [Documentation]             Thêm mới hoa hồng trùng tên
    ${name}                     Get Random Name Commission
    ${resp}                     Create Commission             123456                   ${name}                 400
    Get mess_expected    ${resp}    $.errors..message    Tên bảng hoa hồng đã tồn tại trên hệ thống

Create empty commission         [Tags]                        all                      commission
    [Documentation]             Thêm mới hoa hồng rỗng
    ${resp}                     Create Commission             123456                   \ \                    400
    Get mess_expected    ${resp}    $.errors..message    Bạn chưa nhập Tên bảng hoa hồng

Update commission               [Tags]                        all                     commission
    [Documentation]             Cập nhật hoa hồng
    Update Commission

Delete commission               [Tags]                        all                     commission
    [Documentation]             Xóa hoa hồng
    ${id_commmission}           Get Random ID Commission
    Delete Commission           ${id_commmission}

*** Keywords ***
