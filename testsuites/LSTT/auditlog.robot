*** Settings ***
Library         JSONLibrary
Library         Collections
Library         RequestsLibrary
Resource   ../../core/Share/enviroment.robot
Resource  ../../core/Share/share.robot
Resource   ../../core/Share/share_random.robot
Suite setup     Fill enviroment and get token    ${env}
*** Variables ***
${enp_auditlog}            /logs?format=json&$inlinecount=allpages&FunctionIds=200&FromDate=[D0]&ToDate=[D1]&$top=10
${iso_time}                T17:00:00.000Z
*** TestCases ***
Get Audit_log in today       [Tags]              audit                  allretailer      allfnb          allbooking
    [Documentation]         Xem log lịch sử thao tác hôm nay
    ${year}                 Get Time   year
    ${month}                Get Time  month
    ${day}                  Get Time   day
    ${day}                 Convert To Integer       ${day}
    ${day_before}=          Evaluate                ${day} -1
    ${list_format}          Create List             ${year}-${month}-${day_before}${iso_time}          ${year}-${month}-${day}${iso_time}
    ${enp_auditlog}         Format String Use [D0] [D1] [D2]           ${enp_auditlog}                 ${list_format}
    ${resp}                 Get Request From KV     ${session_man}     ${enp_auditlog}
    ${log_audit}            Get Value From Json KV                     ${resp}          $.Total
    ${is_audit_TS}          Should Be True          ${log_audit}>0                      Nếu testcase này fail là kiểm tra manual lại xem lịch sử thao tác xem có log lstt của timesheet hay ko
