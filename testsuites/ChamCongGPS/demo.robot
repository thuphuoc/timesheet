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
@{address}                      1               2           3
*** TestCases ***
Get kkkk      [Tags]            demo
    ${list}                 Create List    1     2    3
    ${length}                   Get Length           ${list}
    :FOR                    ${i}    IN RANGE        ${length}
    \                       Log                     @{list}[${i}]
