*** Settings ***
Library         JSONLibrary
Library         RequestsLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/1nhanvien/allowance.robot
Suite setup     Fill enviroment and get token    ${env}
Suite Teardown  Test After
*** Variables ***
${type}               1
${value}              4000
${valueRadio}         0
${is_checked}         true

# type: 1( pc moi ngay vnd, pc %) , 0:( pc co dinh), 2: ( pc cong chuan)
# ValueRatio:3: ( pc %), 0(con lai)
# IsChecked: false ( pc %) , con lai true
*** TestCases ***
Create allowance for everyday       [Tags]    allretailer      allfnb          allbooking    allowance
    [Documentation]                 Thêm mới phụ cấp cho mỗi ngày công làm việc theo VND
    ${resp}                         Create Allowance                    0                     ${random_str}         ${type}           ${value}     ${valueRadio}        ${is_checked}    200

Create fixed allowance              [Tags]    allretailer      allfnb          allbooking    allowance
    [Documentation]                 Thêm mới phụ cấp cố định
    ${random_str}                   Random a String lower    5
    ${resp}                         Create Allowance                    0                     ${random_str}         0                ${value}       3        ${is_checked}    200

Create standard allowance           [Tags]    allretailer      allfnb          allbooking    allowance
    [Documentation]                 Thêm mới phụ cấp theo ngày công chuẩn
    ${random_str}                   Random a String lower    5
    ${resp}                         Create Allowance                    0                     ${random_str}         2                ${value}     ${valueRadio}        ${is_checked}    200

Create percent allowance            [Tags]    allretailer      allfnb          allbooking    allowance
    [Documentation]                 Thêm mới phụ cấp theo % lương chính
    ${random_str}                   Random a String lower    5
    ${resp}                         Create Allowance                    0                     ${random_str}         ${type}          2              3                 false    200

Create duplicate allowance          [Tags]    allretailer      allfnb          allbooking    allowance
    [Documentation]                 Thêm mới phụ cấp trùng tên
    ${name}                         Get name Allowance
    ${resp}                         Create Allowance                    0                     ${name}               ${type}           ${value}    ${valueRadio}        ${is_checked}    400
    ${mess_err}                     Get Value From Json KV              ${resp}               $.errors..message
    Should Be Equal                 ${mess_err}                         Tên phụ cấp đã tồn tại trên hệ thống

Create empty allowance              [Tags]    allretailer      allfnb          allbooking    allowance
    [Documentation]                 Thêm mới phụ cấp rỗng
    ${resp}                         Create Allowance                    0                     \ \                   ${type}           ${value}    ${valueRadio}        ${is_checked}    400
    ${mess_err}                     Get Value From Json KV              ${resp}               $.errors..message
    Should Be Equal                 ${mess_err}                         Tên phụ cấp không được để trống

Update allowance                    [Tags]    allretailer      allfnb          allbooking    allowance
    [Documentation]                 Update phụ cấp
    ${resp}                         Update Allowance                    Update ${random_str}                       ${type}            ${value}      ${valueRadio}        ${is_checked}

Delete allowance                    [Tags]   all    allowance
    [Documentation]                 Xóa phụ cấp
    Delete Allowance

*** Keywords ***
Test After
    Delete Allowance
