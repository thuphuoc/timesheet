*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
${data_holiday}                 {"holiday":{"id":[D0],"name":"[D1]","from":"[D2]","to":"[D3]"},"isCancelClocking":false,"isOverLapClocking":true}
${enp_holiday}                  /holidays
*** TestCases ***
Create holiday                  [Tags]      all        holiday
    [Documentation]             Thêm mới ngày lễ
    ${list_format}              Create List                           123456                  ${random_str}                     12/01/2022            12/01/2022
    ${data_holiday}             Format String Use [D0] [D1] [D2]      ${data_holiday}         ${list_format}
    ${resp}                     Post Request Json KV                  ${session}              ${enp_holiday}                     ${data_holiday}      200
    ${id_holiday}               Get Value From Json KV                ${resp}                 $.result.id
    Set Suite Variable          ${id_holiday}                         ${id_holiday}

Create duplicate holiday        [Tags]      all        holiday
    [Documentation]             Thêm mới ngày lễ trùng ngày với ngày lễ đã có trước đó
    ${list_format}              Create List                           123456                  ${random_str}                     12/01/2022            12/01/2022
    ${data_holiday}             Format String Use [D0] [D1] [D2]      ${data_holiday}         ${list_format}
    ${resp}                     Create Value Duplicate Emplty          ${session}              ${enp_holiday}                   ${data_holiday}        Kỳ lễ tết đang trùng ngày với kỳ lễ tết khác.
Create empty holiday            [Tags]      all        holiday
    [Documentation]             Thêm mới ngày lễ rỗng
    ${list_format}              Create List                           123456                  \ \                               14/01/2022            14/01/2022
    ${data_holiday}             Format String Use [D0] [D1] [D2]      ${data_holiday}         ${list_format}
    ${resp}                     Create Value Duplicate Emplty          ${session}             ${enp_holiday}                    ${data_holiday}       Bạn chưa nhập Tên kỳ lễ tết

Update holiday                  [Tags]      all        holiday
    [Documentation]             Cập nhật ngày lễ
    ${list_format}              Create List                           ${id_holiday}           Update ${random_str}              19/05/2022            19/05/2022
    ${data_holiday}             Format String Use [D0] [D1] [D2]      ${data_holiday}         ${list_format}
    ${resp}                     Update Request Json KV                ${session}              ${enp_holiday}/${id_holiday}      ${data_holiday}       200

Delete holiday                  [Tags]      all        holiday
    [Documentation]             Xóa ngày lễ
    ${resp}                     Delete Request KV                     ${session}              ${enp_holiday}/${id_holiday}      200
*** Keywords ***
