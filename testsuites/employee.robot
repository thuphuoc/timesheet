***Settings***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token   zone12

***Variables***
${enp_employee}       /employees
${url}                https://api-timesheet.kiotviet.vn
${data_employee}    {"name":"[D0]","branchId":302728,"tenantId":55955,"temploc":"","tempw":"","workBranchIds":[302728]}
${data_employee_update}     {"id":"30000000123311","code":"NV001605","name":"[D0]","branchId":302728,"tenantId":55955,"workBranchIds":[302728]}
*** Test Cases ***
# Create employee     [Tags]    employee
#     [Documentation]   Create employee valid
#     ${random_str}   Random a String Letter    4
#     Set Global Variable    ${random_str}   ${random_str}
#     ${list_format}    Create List    ${random_str}
#     ${data}   Format String Use [D0] [D1] [D2]    ${data_employee}      ${list_format}
#     ${data}   Evaluate    (None,'${data}')
#     Log    ${data}
#     ${formdata}   Create Dictionary    employee=${data}
#     Log    ${formdata}
#     ${resp}   Post Request Use Formdata KV    ${session}    ${enp_employee}    ${formdata}   200
#     ${id_employee}    Get Value From Json KV    ${resp.json()}   $.result.id
#     ${code_employee}    Get Value From Json KV     ${resp.json()}    $.result.code
#     Set Global Variable      ${code_employee}    ${code_employee}
#     Set Global Variable      ${id_employee}   ${id_employee}
#     Verify input and output of add employee     ${random_str}
Update employee
    ${list}   Create List     Thanh
    ${data}  Format String Use [D0] [D1] [D2]       ${data_employee_update}    ${list}
    ${data}   Evaluate    (None,'${data}')
    ${formdata}   Create Dictionary    employee=${data}
    Log    ${formdata}
    ${resp}  Put   ${session}    ${enp_employee}/30000000123311    ${headers_not_contenType}   files=${formdata}



# Delete employee     [Tags]    delete employee
#     Delete Request KV    ${session}    ${enp_employee}    ${id_employee}    200
***Keywords***
Verify input and output of add employee
    [Arguments]   ${input}
    ${name_employee_output}   Get detail from id KV    ${enp_employee}     ${id_employee}    $.result.name
    Should Be Equal As Strings     ${input}      ${name_employee_output}
