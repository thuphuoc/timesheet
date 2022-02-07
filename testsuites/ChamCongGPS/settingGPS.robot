*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../../core/share/enviroment.robot
Resource  ../../core/share/share.robot
Resource   ../../core/share/share_random.robot
Suite setup  Fill enviroment and get token     ${env}
*** Variables ***
${enp_settingGPS}         /settings/updateUseClockingGps
${data_settingGPS}        {"UseClockingGps":[D0]}
${on_off}                 true
*** TestCases ***
On setting GPS              [Tags]      all           settingGPS
    [Documentation]         Bật thiết lập chấm công GPS
    ${list_format}          Create List    ${on_off}
    ${data_settingGPS}      Format String Use [D0] [D1] [D2]      ${data_settingGPS}    ${list_format}
    ${resp}                 Post Request Json KV    ${session}    ${enp_settingGPS}     ${data_settingGPS}     200
*** Keywords ***
