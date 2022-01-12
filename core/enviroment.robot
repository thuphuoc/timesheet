***Settings***
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections
Library   String
Resource   share.robot
***Variables***
# ${url_saleLogin}    https://${retailer}.kiotviet.vn/api
# ${enp_saleLogin}    /auth/salelogin
# ${url}              https://api-timesheet.kiotviet.vn

*** Keywords ***
Fill enviroment and get token
    [Arguments]                   ${env}
    ${dict_url_saleLogin}         Create Dictionary             zone5=https://testz5.kiotviet.vn/api
    ...                                                         zone13=https://testz13.kiotviet.vn/api
    ...                                                         zone12=https://testz12.kiotviet.vn/api
    ...                                                         zone14=https://testz14.kiotviet.vn/api
    ...
    ${dict_enp_saleLogin}         Create Dictionary             zone5=/auth/salelogin
    ...                                                         zone13=/auth/salelogin
    ...                                                         zone12=/auth/salelogin
    ...                                                         zone14=/auth/salelogin

    ${dict_url}                   Create Dictionary             zone5= https://api-timesheet.kiotviet.vn
    ...                                                         zone13= https://api-timesheet.kiotviet.vn
    ...                                                         zone12= https://api-timesheet.kiotviet.vn
    ...                                                         zone14= https://api-timesheet.kiotviet.vn

    ${dict_username}              Create Dictionary             zone5=admin            zone13=admin         zone12=admin        zone14=admin
    ${dict_password}              Create Dictionary             zone5=123456           zone13=123456        zone12=123456       zone14=123456
    ${dict_retailer}              Create Dictionary             zone5=testz12          zone13=testz5        zone12=testz5       zone14=testz5
    ###################################################################################################################################################################################
    ${username}                   get From Dictionary           ${dict_username}        ${env}
    ${password}                   get From Dictionary           ${dict_password}        ${env}
    ${retailer}                   get From Dictionary           ${dict_retailer}        ${env}
    ${url_saleLogin}              get From Dictionary           ${dict_url_saleLogin}   ${env}
    ${enp_saleLogin}              get From Dictionary           ${dict_enp_saleLogin}   ${env}
    ${url}                        get From Dictionary           ${dict_url}             ${env}
    Set Global Variable           ${username}                   ${username}
    Set Global Variable           ${password}                   ${password}
    Set Global Variable           ${retailer}                   ${retailer}
    Set Global Variable           ${url_saleLogin}              ${url_saleLogin}
    Set Global Variable           ${enp_saleLogin}              ${enp_saleLogin}
    Set Global Variable           ${url}                        ${url}
############################################################################################################################################################################

    ${header}                     Create Dictionary             retailer=${retailer}    Content-Type=application/json;charset=utf-8
    ${data_saleLogin}             Create Dictionary             UserName=${username}    Password=${password}
    Create Session                sessionLogin                  ${url_saleLogin}
    ${resp}                       Post Request                  sessionLogin            ${enp_saleLogin}   ${header}     ${data_saleLogin}
    Log                           ${resp.json()}
    ${token}                      Get Value From Json KV        ${resp.json()}          $.BearerToken
    ${token}                      Catenate    Bearer            ${token}
    ${branchId}                   Get Value From Json KV        ${resp.json()}          $.CurrentBranchId
    ${branchId}                   Convert To String             ${branchId}
    Set Global Variable           ${branchId}                   ${branchId}
    ${user_login}                 Get Value From Json KV        ${resp.json()}          $.UserId
    Set Global Variable           ${user_login}                 ${user_login}
    ${header}                     Create Dictionary             retailer=${retailer}    Content-Type=application/json;charset=utf-8    branchid=${branchId}     Authorization=${token}
    ${headers_not_contenType}     Create Dictionary             retailer=${retailer}    branchid=${branchId}     Authorization=${token}
    Set Global Variable           ${header}                     ${header}
    Set Global Variable           ${headers_not_contenType}     ${headers_not_contenType}
    Create Session                session    ${url}             ${headers_not_contenType}
    Set Global Variable           ${session}                    session
    ${random_str}=                Random a String Letter        4
    Set Global Variable           ${random_str}                 ${random_str}
    ${random_number}=             Random a Number               8
    Set Global Variable           ${random_number}              ${random_number}
