*** Settings ***
Library         JSONLibrary
Library         RequestsLibrary
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Suite setup     Fill enviroment and get token    ${env}
*** Variables ***
${data_setting_payroll}     {"Data":{"earlyTime":[D0],"lateTime":[D1],"earlyTimeOT":[D2],"lateTimeOT":[D3],"isAutoCalcEarlyTime":true,"isAutoCalcEarlyTimeOT":true,"isAutoCalcLateTime":true,"isAutoCalcLateTimeOT":true,"isAutoTimekeepingMultiple":false,"maxShiftIsAutoTimekeepingMultiple":2,"rangeShiftIsAutoTimekeepingMultipleHours":1,"rangeShiftIsAutoTimekeepingMultipleMinutes":0,"halfShiftIsActive":[D4],"halfShiftMaxHour":[D5],"halfShiftMaxMinute":[D6],"startDateOfEveryMonth":1,"firstStartDateOfTwiceAMonth":31,"secondStartDateOfTwiceAMonth":7,"startDayOfWeekEveryWeek":2,"startDayOfWeekTwiceWeekly":3,"standardWorkingDay":[D7]}}
${enp_setting}                /settings
${halfShiftIsActive}          true
${halfShiftMaxHour}           4
${halfShiftMaxMinute}         15
${standardWorkingDay}         8
${earlyTime}                  15
${lateTime}                   20
${earlyTimeOT}                30
${lateTimeOT}                 30
*** TestCases ***
Setting payroll and timesheet     [Tags]          all           settingpayrollandTS
      [Documentation]             Thiết lập lương và chấm công cho nhân viên
      ${list_format}              Create List                         ${earlyTime}   ${lateTime}   ${earlyTimeOT}     ${lateTimeOT}        ${halfShiftIsActive}         ${halfShiftMaxHour}    ${halfShiftMaxMinute}   ${standardWorkingDay}
      ${data_setting_payroll}     Format String Use [D0] [D1] [D2]    ${data_setting_payroll}      ${list_format}
      ${resp}                     Post Request Json KV                ${session}                   ${enp_setting}         ${data_setting_payroll}    200

*** Keywords ***
