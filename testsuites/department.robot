***Settings***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Suite setup  Fill enviroment and get token    zone12

***Variables***
${enp_department}     /employees/department
${url}                https://api-timesheet.kiotviet.vn
${data_department}    {"department":{"name":[D0],"isActive":true}}
*** Test Cases ***
Create department
    # Post Request Json    data_func    firstname_data    enpoint    list_format
    ${resp}   Post Request Json    ${data_department}    department    ${enp_department}    Phong1704
    Should Be Equal As Strings    ${resp.status_code}    200
***Keywords***
