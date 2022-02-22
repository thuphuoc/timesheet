*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Library     Collections
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/GPS/gps.robot
Resource        ../../core/ChiNhanh/branch.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
${address}                      số 10
${radiusLimit}                  200
${address_up}                   số 11
*** TestCases ***
Create gps    [Tags]            all             gps
    [Documentation]             Thêm mới gps cho 1 chi nhánh để chấm công bằng mobile
    ${id_branch}                Get A Branch In Active Branchs
    ${name_branch}              Get Name Branch From Id    ${id_branch}
    Set Suite Variable          ${id_branch}    ${id_branch}
    ${resp}                     Create GPS      ${random_number}        ${id_branch}      ${address}        ${radiusLimit}

Update gps      [Tags]            all             gps
    [Documentation]             Chỉnh sửa gps cho 1 chi nhánh để chấm công bằng mobile
    ${id_gps}                   Get A GPS In List GPS
    ${resp}                     Update GPS     ${id_gps}               ${id_branch}      ${address_up}      ${radiusLimit}

Change qr      [Tags]            all             gps
    [Documentation]             Đổi mã QR của chi nhánh
    ${id_gps}                   Get A GPS In List GPS
    ${resp}                     Change QR                   ${id_gps}

Delete gps      [Tags]            all             gps
    [Documentation]             Xóa gps của 1 chi nhánh
    ${id_gps}                   Get A GPS In List GPS
    Delete GPS                  ${id_gps}
