***Settings***
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections
Library   String
Resource   share.robot
***Variables***
${url_saleLogin}    https://testz12.kiotviet.vn/api
${enp_saleLogin}    /auth/salelogin
${url}              https://api-timesheet.kiotviet.vn

*** Keywords ***
Fill enviroment and get token
    [Arguments]     ${env}
    ${dict_username}   Create Dictionary    zone12=admin
    ${dict_password}   Create Dictionary    zone12=123456
    ${dict_retailer}   Create Dictionary    zone12=testz12
    ##############################################################
    ${username}   get From Dictionary     ${dict_username}   ${env}
    ${password}   get From Dictionary     ${dict_password}   ${env}
    ${retailer}   get From Dictionary     ${dict_retailer}   ${env}
    Set Global Variable      ${username}      ${username}
    Set Global Variable      ${password}      ${password}
    Set Global Variable      ${retailer}      ${retailer}

#################################################################

    ${header}   Create Dictionary      retailer=${retailer}    Content-Type=application/json;charset=utf-8
    ${data_saleLogin}   Create Dictionary    UserName=${username}    Password=${password}
    Create Session    sessionLogin    ${url_saleLogin}
    ${resp}   Post Request    sessionLogin    ${enp_saleLogin}   ${header}     ${data_saleLogin}
    ${token}    Get Value From Json KV    ${resp.json()}   $.BearerToken
    ${token}    Catenate    Bearer  ${token}
    ${branchId}    Get Value From Json KV  ${resp.json()}   $.CurrentBranchId
    ${branchId}   Convert To String    ${branchId}
    Set Global Variable      ${branchId}      ${branchId}
    ${header}   Create Dictionary    retailer=${retailer}    Content-Type=application/json;charset=utf-8    branchid=${branchId}     Authorization=${token}
    ${headers_not_contenType}   Create Dictionary    retailer=${retailer}    branchid=${branchId}     Authorization=${token}
    Set Global Variable    ${header}    ${header}
    Set Global Variable    ${headers_not_contenType}   ${headers_not_contenType}
    Create Session    session    ${url}   ${headers_not_contenType}
    Set Global Variable    ${session}    session
