***Settings***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token    zone12

***Variables***
${enp_employee}       /employees
${url}                https://api-timesheet.kiotviet.vn
${data_employee}    {"name":"[D0]","branchId":302728,"tenantId":55955,"temploc":"","tempw":"","workBranchIds":[302728]}

*** Test Cases ***
Create employee
    ${random_str}=  Random a String Letter    4
    ${list_format}    Create List    ${random_str}
    ${data}   Format String Use [D0] [D1] [D2]    ${data_employee}      ${list_format}
    ${data}   Evaluate    (None,'${data}')
    Log    ${data}
    ${formdata}   Create Dictionary    employee=${data}
    Log    ${formdata}
    ${resp}   Post Request Use Formdata    ${session}    ${enp_employee}    ${formdata}   200
***Keywords***
