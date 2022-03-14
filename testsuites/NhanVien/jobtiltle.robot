*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Suite setup  Fill enviroment and get token     ${env}

*** Variables ***
${enp_job}                           /employees/job-title
${data_job}                          {"jobTitle":{"id":[D0],"name":"[D1]","isActive":true}}
${id_jobtitle}                       123456
*** TestCases ***
Create jobtitle                       [Tags]    allretailer      allfnb          allbooking        jobtitle
    [Documentation]                   Thêm mới chức danh
    ${list_format}                    Create List                             ${id_jobtitle}            ${random_str}
    ${data}                           Format String Use [D0] [D1] [D2]        ${data_job}               ${list_format}
    ${resp}                           Post Request Json KV                    ${session}                ${enp_job}                ${data}                         200

Create duplicate jobtitle             [Tags]    allretailer      allfnb          allbooking       jobtitle
    [Documentation]                   Thêm mới chức danh trùng tên
    ${name}                           Get Value In List KV                    ${session}                ${enp_job}                $.result.data..name
    ${list_format}                    Create List                             ${id_jobtitle}            ${name}
    ${data_job}                       Format String Use [D0] [D1] [D2]        ${data_job}               ${list_format}
    ${resp}                           Create Value Duplicate Emplty            ${session}               ${enp_job}                ${data_job}               Tên chức danh đã tồn tại trên hệ thống

Create empty jobtitle                 [Tags]    allretailer      allfnb          allbooking        jobtitle
    [Documentation]                   Thêm mới chức danh rỗng
    ${list_format}                    Create List                             ${id_jobtitle}            \ \
    ${data_job}                       Format String Use [D0] [D1] [D2]        ${data_job}               ${list_format}
    ${resp}                           Create Value Duplicate Emplty           ${session}                ${enp_job}               ${data_job}               Tên chức danh không được để trống

Update jobtitle                       [Tags]    allretailer      allfnb          allbooking        jobtitle
    [Documentation]                   Cập nhật chức danh
    ${id_job}                         Get Value In List KV                    ${session}                ${enp_job}                $.result.data..id
    ${list_format}                    Create List                             ${id_job}                 Update ${random_str}
    ${data}                           Format String Use [D0] [D1] [D2]        ${data_job}               ${list_format}
    ${resp}                           Update Request Json KV                  ${session}                ${enp_job}/${id_job}      ${data}                   200

Delete jobtitle                       [Tags]    allretailer      allfnb          allbooking        jobtitle
   [Documentation]                    Xóa chức danh
    ${id_job}                         Get Value In List KV                    ${session}                ${enp_job}                $.result.data..id
    Delete Request KV                 ${session}    ${enp_job}/${id_job}      200
*** Keywords ***
