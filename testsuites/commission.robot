*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
${data_commission}            {"commission":{"id":[D0],"name":"[D1]","isAllBranch":true,"branchIds":[],"isActive":true}}
${enp_commission}             /commission
*** TestCases ***
Create commission               [Tags]      all        commission
    [Documentation]             Thêm mới hoa hồng
    ${list_format}              Create List                           123456                  ${random_str}
    ${data_commission}          Format String Use [D0] [D1] [D2]      ${data_commission}      ${list_format}
    ${resp}                     Post Request Json KV                  ${session}              ${enp_commission}       ${data_commission}    200
    ${id_commmission}           Get Value From Json KV                ${resp}                 $.result.id
    Set Suite Variable          ${id_commmission}                     ${id_commmission}

Create duplicate commission     [Tags]      all        commission
    [Documentation]             Thêm mới hoa hồng trùng tên
    ${resp}                     Get Request from KV                   ${session}              ${enp_commission}
    ${name}                     Get Value From Json KV                ${resp}                 $.result.data..name
    ${list_format}              Create List                           123456                  ${name}
    ${data_commission}          Format String Use [D0] [D1] [D2]      ${data_commission}      ${list_format}
    ${resp}                     Create value duplicate_empty          ${enp_commission}       ${data_commission}      Tên bảng hoa hồng đã tồn tại trên hệ thống

Create empty commission         [Tags]      all        commission
    [Documentation]             Thêm mới hoa hồng rỗng
    ${list_format}              Create List                           123456                     \ \
    ${data_commission}          Format String Use [D0] [D1] [D2]      ${data_commission}      ${list_format}
    ${resp}                     Create value duplicate_empty          ${enp_commission}       ${data_commission}       Bạn chưa nhập Tên bảng hoa hồng

Update commission               [Tags]      all        commission
    [Documentation]             Cập nhật hoa hồng
    ${resp}                     Get Request from KV                   ${session}              ${enp_commission}
    ${id_commmission}           Get Value From Json KV                ${resp}                 $.result.data..id
    ${list_format}              Create List                           ${id_commmission}       Update ${random_str}
    ${data_commission}          Format String Use [D0] [D1] [D2]      ${data_commission}      ${list_format}
    ${resp}                     Update Request KV                     ${session}              ${enp_commission}         ${data_commission}    200
    ${mess_expected}            Get Value From Json KV                ${resp}                 $.message
    Should Be Equal             ${mess_expected}                      Cập nhật hoa hồng thành công
Delete commission               [Tags]      all        commission
    [Documentation]             Xóa hoa hồng
    ${resp}                     Delete Request KV    ${session}       ${enp_commission}/${id_commmission}                200
*** Keywords ***
