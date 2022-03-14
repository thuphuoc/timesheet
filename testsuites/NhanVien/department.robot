***Settings***
Library     JSONLibrary
Library     RequestsLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Suite setup  Fill enviroment and get token     ${env}

***Variables***
${enp_department}                     /employees/department
${data_department}                    {"department":{"id":"[D0]","name":"[D1]","isActive":true}}

*** Test Cases ***
Create department                     [Tags]    allretailer      allfnb          allbooking  department
    [Documentation]                   Thêm mới phòng ban
    ${list_format}                    Create List                           123456                  ${random_str}
    ${data}                           Format String Use [D0] [D1] [D2]      ${data_department}      ${list_format}
    ${resp}                           Post Request Json KV                  ${session}              ${enp_department}       ${data}         200

Create department duplicate name      [Tags]    allretailer      allfnb          allbooking  department
    [Documentation]                   Thêm mới phòng ban trùng tên
    ${name}                           Get Value In List KV                  ${session}              ${enp_department}       $.result.data..name
    ${list_format}                    Create List                           123456                  ${name}
    ${data_department}                Format String Use [D0] [D1] [D2]      ${data_department}      ${list_format}
    Create Value Duplicate Emplty      ${session}                            ${enp_department}      ${data_department}      Tên phòng ban đã tồn tại trên hệ thống

Create department empty name          [Tags]    allretailer      allfnb          allbooking  department
    [Documentation]                   Thêm mới phòng ban rỗng
    ${list_format}                    Create List                           123456     \ \
    ${data_department}                Format String Use [D0] [D1] [D2]      ${data_department}      ${list_format}
    Create Value Duplicate Emplty      ${session}                            ${enp_department}      ${data_department}      Tên phòng ban không được để trống

Update department                     [Tags]    allretailer      allfnb          allbooking  department
    [Documentation]                   Cập nhật phòng ban
    ${id_department}                  Get Value In List KV                  ${session}              ${enp_department}       $.result..id
    Set Global Variable               ${id_department}                      ${id_department}
    ${list_format}                    Create List                           ${id_department}        Update ${random_str}
    ${data}                           Format String Use [D0] [D1] [D2]      ${data_department}      ${list_format}
    ${resp}                           Update Request Json KV                ${session}              ${enp_department}/${id_department}    ${data}        200

Delete department                     [Tags]    allretailer      allfnb          allbooking  department
  [Documentation]                     Xóa phòng ban
  Delete Request KV                   ${session}                            ${enp_department}/${id_department}              200
***Keywords***
