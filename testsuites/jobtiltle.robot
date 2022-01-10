*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token     ${env}

*** Variables ***
${enp_job}            /employees/job-title
${data_job}           {"jobTitle":{"name":"[D0]","isActive":true}}
${data_upd_job}       {"jobTitle":{"id":[D0],"name":"[D1]","isActive":true}}
*** TestCases ***
Create jobtitle             [Tags]        jobtitle
    ${list_format}    Create List         ${random_str}
    ${data}           Format String Use [D0] [D1] [D2]    ${data_job}    ${list_format}
    Post Request Json KV    ${session}    ${enp_job}      ${data}        200
Create duplicate jobtitle   [Tags]        Create duplicate jobtitle
    ${name}   Get value in list KV    ${enp_job}     $.result.data..name
    ${list_format}    Create List         ${name}
    ${data_job}           Format String Use [D0] [D1] [D2]    ${data_job}    ${list_format}
    Create value duplicate_empty      ${enp_job}           ${data_job}    Tên chức danh đã tồn tại trên hệ thống
Create empty jobtitle       [Tags]        jobtitle
    ${list_format}    Create List        \ \
    ${data_job}       Format String Use [D0] [D1] [D2]    ${data_job}    ${list_format}
    Create value duplicate_empty      ${enp_job}    ${data_job}          Tên chức danh không được để trống
Update jobtitle             [Tags]        jobtitle
    ${id_job}         Get value in list KV                ${enp_job}         $.result.data..id
    ${list_format}    Create List     ${id_job}           Update ${random_str}
    ${data}           Format String Use [D0] [D1] [D2]    ${data_upd_job}    ${list_format}
    ${resp}           Update Request KV    ${session}     ${enp_job}/${id_job}      ${data}    200
Delete jobtitle             [Tags]        jobtitle
    ${id_job}              Get value in list KV                ${enp_job}         $.result.data..id
    Delete Request KV      ${session}    ${enp_job}/${id_job}      200
*** Keywords ***
