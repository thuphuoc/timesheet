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
${result}                3.14

*** TestCases ***
ddd    [Tags]               demo
    # ${status} =   Should Be True    ${result}>3.14
    Should Be Equal    ${result}    3.14            ko ok
