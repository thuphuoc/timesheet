*** Settings ***
Library         JSONLibrary
Library         RequestsLibrary
Resource        ../core/enviroment.robot
Resource        ../core/share.robot
Resource        ../core/share_random.robot
Suite setup     Fill enviroment and get token    ${env}

*** Variables ***
${enp_allowance}                    /allowance
${data_allowance}                   {"allowance":{"Id":"[D0]","Name":"[D1]","Type":[D2],"Value":[D3],"ValueRatio":0,"IsChecked":true}}

*** TestCases ***
Create allowance                    [Tags]   all    allowance    payrate
    [Documentation]                 Thêm mới phụ cấp
    ${list_format}                  Create List                           Null                  ${random_str}                   1                       20000
    ${data_allowance}               Format String Use [D0] [D1] [D2]      ${data_allowance}     ${list_format}
    ${resp}                         Post Request Json KV                  ${session}            ${enp_allowance}           ${data_allowance}             200
    ${id_allowance}                 Get Value From Json KV                ${resp}               $.result.id
    Set Global Variable             ${id_allowance}                       ${id_allowance}

Create duplicate allowance          [Tags]   all    allowance
    [Documentation]                 Thêm mới phụ cấp trùng tên
    ${name}                         Get value in list KV                  ${session}            ${enp_allowance}      $.result.data..name
    ${list_format}                  Create List                           Null                  ${name}                           0                             10000
    ${data_allowance}               Format String Use [D0] [D1] [D2]      ${data_allowance}     ${list_format}
    ${resp}                         Create value duplicate_empty          ${session}            ${enp_allowance}      ${data_allowance}             Tên phụ cấp đã tồn tại trên hệ thống

Create empty allowance              [Tags]   all    allowance
    [Documentation]                 Thêm mới phụ cấp rỗng
    ${list_format}                  Create List                           Null      \ \     0             10000
    ${data_allowance}               Format String Use [D0] [D1] [D2]      ${data_allowance}     ${list_format}
    ${resp}                         Create value duplicate_empty          ${session}            ${enp_allowance}      ${data_allowance}     Tên phụ cấp không được để trống

Update allowance                    [Tags]   all    allowance
    [Documentation]                 Update phụ cấp
    ${id_allowance}                 Get value in list KV   ${session}     ${enp_allowance}      $.result.data..id
    ${list_format}                  Create List                           ${id_allowance}       Update ${random_str}     1          20000
    ${data_allowance}               Format String Use [D0] [D1] [D2]      ${data_allowance}     ${list_format}
    Update Request KV               ${session}                            ${enp_allowance}/${id_allowance}        ${data_allowance}    200

Delete allowance                    [Tags]   all    allowance
    [Documentation]                 Xóa phụ cấp
    ${id_allowance}                 Get value in list KV                  ${session}            ${enp_allowance}                        $.result.data..id
    Delete Request KV               ${session}                            ${enp_allowance}/${id_allowance}        200

*** Keywords ***
