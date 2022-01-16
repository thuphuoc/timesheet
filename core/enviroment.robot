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
    ${dict_url_saleLogin}         Create Dictionary             zone5=https://auto5.kiotviet.vn/api
    ...                                                         zone13=https://auto13.kiotviet.vn/api
    ...                                                         zone12=https://auto12.kiotviet.vn/api
    ...                                                         zone14=https://auto14.kiotviet.vn/api
    ...                                                         59902=
    ...                                                         59903=
    ${dict_enp_saleLogin}         Create Dictionary             zone5=/auth/salelogin
    ...                                                         zone13=/auth/salelogin
    ...                                                         zone12=/auth/salelogin
    ...                                                         zone14=/auth/salelogin
    ...                                                         59902=/auth/salelogin
    ...                                                         59903=/auth/salelogin
    ${dict_url}                   Create Dictionary             zone5= https://api-timesheet.kiotviet.vn
    ...                                                         zone13= https://api-timesheet.kiotviet.vn
    ...                                                         zone12= https://api-timesheet.kiotviet.vn
    ...                                                         zone14= https://api-timesheet.kiotviet.vn
    ...                                                         59902=
    ...                                                         59903=
    ${dict_url_man}               Create Dictionary             zone5=https://api-man.kiotviet.vn/api
    ...                                                         zone13=https://api-man.kiotviet.vn/api
    ...                                                         zone12=https://api-man.kiotviet.vn/api
    ...                                                         zone14=https://api-man.kiotviet.vn/api
    ...                                                         59903=
    ...                                                         59903=
    ${dict_username}              Create Dictionary             zone5=admin             zone13=admin        zone12=admin        zone14=admin        59902=1             59903=1
    ${dict_password}              Create Dictionary             zone5=123               zone13=123          zone12=123          zone14=123          59902=1             59903=1
    ${dict_retailer}              Create Dictionary             zone5=auto5             zone13=auto13       zone12=auto12       zone14=auto14       59902=phuoc902      59903=phuoc903
    ###################################################################################################################################################################################
    ${username}                   get From Dictionary           ${dict_username}        ${env}
    ${password}                   get From Dictionary           ${dict_password}        ${env}
    ${retailer}                   get From Dictionary           ${dict_retailer}        ${env}
    ${url_saleLogin}              get From Dictionary           ${dict_url_saleLogin}   ${env}
    ${enp_saleLogin}              get From Dictionary           ${dict_enp_saleLogin}   ${env}
    ${url}                        get From Dictionary           ${dict_url}             ${env}
    ${url_man}                    get From Dictionary           ${dict_url_man}         ${env}
    Set Global Variable           ${username}                   ${username}
    Set Global Variable           ${password}                   ${password}
    Set Global Variable           ${retailer}                   ${retailer}
    Set Global Variable           ${url_saleLogin}              ${url_saleLogin}
    Set Global Variable           ${enp_saleLogin}              ${enp_saleLogin}
    Set Global Variable           ${url}                        ${url}
    Set Global Variable           ${url_man}                    ${url_man}
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
    Create Session                sessionMan                    ${url_man}              ${header}
    Set Global Variable           ${session}                    session
    Set Global Variable           ${session_man}                sessionMan
    ${random_str}=                Random a String Letter        4
    Set Global Variable           ${random_str}                 ${random_str}
    ${random_number}=             Random a Number               8
    Set Global Variable           ${random_number}              ${random_number}
