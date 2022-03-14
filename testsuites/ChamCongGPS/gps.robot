*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Library     Collections
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/ChamCongGPS/gps.robot
Resource        ../../core/ChiNhanh/branch.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
${address}                      số 10
${radiusLimit}                  200
${address_up}                   số 11
*** TestCases ***

Create gps    [Tags]            allretailer      allfnb          allbooking             gps
    [Documentation]             Thêm mới gps cho 1 chi nhánh để chấm công bằng mobile
    ${id_branch}                Get List Branch Had Not Use GPS
    ${name_branch}              Get Name Branch From Id     ${id_branch}
    Set Suite Variable          ${id_branch}                ${id_branch}
    ${resp}                     Create GPS                  ${random_number}        ${id_branch}      ${address}        ${radiusLimit}

Update gps      [Tags]            allretailer      allfnb          allbooking             gps
    [Documentation]             Chỉnh sửa gps cho 1 chi nhánh để chấm công bằng mobile
    ${id_gps}                   Get A GPS In List GPS
    ${resp}                     Update GPS     ${id_gps}               ${id_branch}      ${address_up}      ${radiusLimit}

Change qr      [Tags]            allretailer      allfnb          allbooking             gps
    [Documentation]             Đổi mã QR của chi nhánh
    ${id_gps}                   Get A GPS In List GPS
    ${resp}                     Change QR                   ${id_gps}

Delete gps      [Tags]            allretailer      allfnb          allbooking             gps1
    [Documentation]             Xóa gps của 1 chi nhánh
    ${id_gps}                   Get A GPS In List GPS
    Delete GPS                  ${id_gps}
***Keywords***
Get List Branch Had Not Use GPS
    ${resp}                     Get List Of Active Branch
    ${list_branch}              Get Value From Json         ${resp}                 $..Id
    ${resp_gps}                 Get List Branch Had Used GPS
    ${list_branch_gps}          Get Value From Json         ${resp_gps}             $..branchId
    ${length}                   Get Length                  ${list_branch_gps}
    :FOR  ${i}  IN RANGE        ${length}
    \                           Remove Values From List    ${list_branch}        @{list_branch_gps}[${i}]
    Log    ${list_branch}
    Log    ${list_branch_gps}
    Set Test Variable           ${list_branch}              ${list_branch}
    ${id_branch_gps}=           Evaluate                    random.choice($list_branch)        random
    Return From Keyword         ${id_branch_gps}
