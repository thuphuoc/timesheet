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
${a}                      Mã nhân viên     đã tồn tại trong cửa hàng
@{address}                      1               2           3
*** TestCases ***
Get kkkk      [Tags]            demo
    ${list}                 Create List    1     2    3
    ${length}                   Get Length           ${list}
    :FOR                    ${i}    IN RANGE        ${length}
    \                       Log                     @{list}[${i}]

Replace String With Empty String        [Tags]            demo1
    ${result} =    Replace String       ${a}    Framework   ${EMPTY}
    log                     ${result}
    Should be equal    ${result}    Mã nhân viên đã tồn tại trong cửa hàng
