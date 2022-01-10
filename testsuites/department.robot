***Settings***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token     ${env}

***Variables***
${enp_department}         /employees/department
${url}                    https://api-timesheet.kiotviet.vn
${data_department}        {"department":{"id":"[D0]","name":"[D1]","isActive":true}}

*** Test Cases ***
Create department                   [Tags]  department
    ${list_format}    Create List           123456        ${random_str}
    ${data}           Format String Use [D0] [D1] [D2]    ${data_department}    ${list_format}
    ${resp}           Post Request Json KV                ${session}            ${enp_department}    ${data}   200
Create department duplicate name    [Tags]  department
    ${name}   Get value in list KV    ${enp_department}    $.result.data..name
    ${list_format}    Create List     123456               ${name}
    ${data_department}   Format String Use [D0] [D1] [D2]  ${data_department}    ${list_format}
    Create value duplicate_empty    ${enp_department}      ${data_department}   Tên phòng ban đã tồn tại trên hệ thống
Create department empty name        [Tags]  department
    ${list_format}    Create List    123456     \ \
    ${data_department}   Format String Use [D0] [D1] [D2]    ${data_department}    ${list_format}
    Create value duplicate_empty     ${enp_department}    ${data_department}    Tên phòng ban không được để trống
Update department                   [Tags]  department
    ${id_department}        Get value in list KV    ${enp_department}    $.result..id
    Set Global Variable     ${id_department}        ${id_department}
    ${list_format}          Create List             ${id_department}   Update ${random_str}
    ${data}   Format String Use [D0] [D1] [D2]      ${data_department}      ${list_format}
    ${resp}   Update Request KV    ${session}       ${enp_department}/${id_department}    ${data}    200
    Log   ${resp}
Delete department                   [Tags]  department
    Delete Request KV       ${session}     ${enp_department}/${id_department}        200
***Keywords***
