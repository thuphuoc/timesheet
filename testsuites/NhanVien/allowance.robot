*** Settings ***
Library         JSONLibrary
Library         RequestsLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/nhanvien/allowance.robot
Suite setup     Fill enviroment and get token    ${env}
Suite Teardown  Test After
*** Variables ***
${type_allowance}     1
${value_allowance}    4000
*** TestCases ***
Create allowance                    [Tags]   all    allowance
    [Documentation]                 Thêm mới phụ cấp
    ${resp}                         Create Allowance                    0                     ${random_str}         ${type_allowance}           ${value_allowance}     200

Create duplicate allowance          [Tags]   all    allowance
    [Documentation]                 Thêm mới phụ cấp trùng tên
    ${name}                         Get name Allowance
    ${resp}                         Create Allowance                    0                     ${name}               ${type_allowance}           ${value_allowance}    400
    ${mess_err}                     Get Value From Json KV              ${resp}               $.errors..message
    Should Be Equal                 ${mess_err}                         Tên phụ cấp đã tồn tại trên hệ thống

Create empty allowance              [Tags]   all    allowance
    [Documentation]                 Thêm mới phụ cấp rỗng
    ${resp}                         Create Allowance                    0                     \ \                   ${type_allowance}           ${value_allowance}    400
    ${mess_err}                     Get Value From Json KV              ${resp}               $.errors..message
    Should Be Equal                 ${mess_err}                         Tên phụ cấp không được để trống

Update allowance                    [Tags]   all    allowance
    [Documentation]                 Update phụ cấp
    ${resp}                         Update Allowance                    Update ${random_str}                       ${type_allowance}            ${value_allowance}

# Delete allowance                    [Tags]   all    allowance
#     [Documentation]                 Xóa phụ cấp
#     Delete Allowance

*** Keywords ***
Test After
    Delete Allowance
