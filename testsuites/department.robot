***Settings***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token    zone12

***Variables***
${enp_department}     /employees/department
${url}                https://api-timesheet.kiotviet.vn
${data_department}    {"department":{"name":"[D0]","isActive":true}}
*** Test Cases ***
Create department
    ${random_str}=  Random a String Letter    4
    ${list_format}    Create List    ${random_str}
    ${data}   Format String Use [D0] [D1] [D2]    ${data_department}      ${list_format}
    ${resp}   Post Request Json KV    ${session}    ${enp_department}    ${data}   200
  
***Keywords***
