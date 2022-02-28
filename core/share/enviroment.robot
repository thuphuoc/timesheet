***Settings***
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections
Library   String
Resource   share.robot
Resource   ../../core/ChiNhanh/branch.robot
***Variables***
*** Keywords ***
Fill enviroment and get token
    [Arguments]                   ${env}
    ${dict_url_saleLogin}         Create Dictionary             zone5=https://auto5.kiotviet.vn/api
    ...                                                         zone13=https://testz13.kiotviet.vn/api
    ...                                                         zone12=https://testz12.kiotviet.vn/api
    ...                                                         zone14=https://auto14.kiotviet.vn/api
    ...                                                         zone61=https://testz61.kiotviet.vn/api
    ...                                                         zone21=https://testz221.kiotviet.vn/api
    ...                                                         zone9=https://taphoa.kiotviet.vn/api
    ...                                                         zone1=https://testz1.kiotviet.vn/api
    ...                                                         zone59902=https://phuoc902.kvpos.com:59302/api
    ...                                                         zone59903=https://phuoc903.kvpos.com:59303/api
    ...                                                         fnb59508=https://phuoc59508.kvpos.com:59508/api
    ...                                                         booking=https://bookinghcm.kvpos.com:9009/api
    ...                                                         fnb15=https://fnb.kiotviet.vn/api

    ${dict_enp_saleLogin}         Create Dictionary             zone5=/auth/salelogin
    ...                                                         zone13=/auth/salelogin
    ...                                                         zone12=/auth/salelogin
    ...                                                         zone1=/auth/salelogin
    ...                                                         zone14=/auth/salelogin
    ...                                                         zone61=/auth/salelogin
    ...                                                         zone21=/auth/salelogin
    ...                                                         zone9=/auth/salelogin
    ...                                                         zone59902=/auth/salelogin
    ...                                                         zone59903=/auth/salelogin
    ...                                                         fnb59508=/auth/salelogin
    ...                                                         booking=/auth/salelogin
    ...                                                         fnb15=/auth/salelogin

    ${dict_url}                   Create Dictionary             zone5=https://api-timesheet.kiotviet.vn
    ...                                                         zone13=https://api-timesheet.kiotviet.vn
    ...                                                         zone12=https://api-timesheet.kiotviet.vn
    ...                                                         zone1=https://api-timesheet.kiotviet.vn
    ...                                                         zone14=https://api-timesheet.kiotviet.vn
    ...                                                         zone61=https://api-timesheet.kiotviet.vn
    ...                                                         zone21=https://api-timesheet.kiotviet.vn
    ...                                                         zone9=https://api-timesheet2.kiotviet.vn
    ...                                                         zone59902=https://kvpos.com:55002
    ...                                                         zone59903=https://kvpos.com:55003
    ...                                                         fnb59508=https://kvpos.com:55008
    ...                                                         booking=https://timesheetapi.kvpos.com:9009
    ...                                                         fnb15=https://api-fnbtimesheet.kiotviet.vn

    ${dict_url_man}               Create Dictionary             zone5=https://api-man.kiotviet.vn/api
    ...                                                         zone13=https://api-man.kiotviet.vn/api
    ...                                                         zone12=https://api-man.kiotviet.vn/api
    ...                                                         zone1=https://api-man.kiotviet.vn/api
    ...                                                         zone14=https://api-man.kiotviet.vn/api
    ...                                                         zone61=https://api-man3.kiotviet.vn/api
    ...                                                         zone21=https://api-man3.kiotviet.vn/api
    ...                                                         zone9=https://api-man3.kiotviet.vn/api
    ...                                                         zone59902=https://kvpos.com:59932/api
    ...                                                         zone59903=https://kvpos.com:59933/api
    ...                                                         fnb59508=https://kvpos.com:59508/api
    ...                                                         booking=https://bookinghcm.kvpos.com:9009/api
    ...                                                         fnb15=https://fnb.kiotviet.vn/api

    ${dict_username}              Create Dictionary             zone5=admin             zone13=admin            zone12=admin        zone14=admin
    ...                                                         zone1=admin             zone9=taphoa            zone61=admin        zone21=admin
    ...                                                         zone59902=1             zone59903=1             fnb59508=1          booking=1
    ...                                                         fnb15=admin
    ${dict_password}              Create Dictionary             zone5=123               zone13=123456           zone12=123456       zone14=123
    ...                                                         zone1=123               zone9=123456            zone61=123456       zone21=123456
    ...                                                         zone59902=1             zone59903=1             fnb59508=1         booking=1
    ...                                                         fnb15=123
    ${dict_retailer}              Create Dictionary             zone5=auto5             zone13=testz13          zone12=testz12      zone14=auto14
    ...                                                         zone1=testz1            zone9=taphoa            zone61=testz61      zone21=testz221
    ...                                                         zone59902=phuoc902      zone59903=phuoc903      fnb59508=phuoc59508                  booking=phuoc009
    ...                                                         fnb15=testfnbz15a

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
#########################################################################################################################################################

    ${header}                     Create Dictionary             retailer=${retailer}    Content-Type=application/json;charset=utf-8
    ${data_saleLogin}             Create Dictionary             UserName=${username}    Password=${password}
    Create Session                sessionLogin                  ${url_saleLogin}
    ${resp}                       Post Request                  sessionLogin            ${enp_saleLogin}   headers=${header}     data=${data_saleLogin}
    Log                           ${resp.json()}
    ${token}                      Get Value From Json KV        ${resp.json()}          $.BearerToken
    ${token}                      Catenate    Bearer            ${token}
    ${user_login}                 Get Value From Json KV        ${resp.json()}          $.UserId
    Set Global Variable           ${user_login}                 ${user_login}
    Set Suite Variable            ${token}                      ${token}
    ${random_str}=                Random a String Letter        4
    Set Global Variable           ${random_str}                 ${random_str}
    ${random_number}=             Random a Number               8
    Set Global Variable           ${random_number}              ${random_number}
    ${branchId}                   Get Value From Json KV        ${resp.json()}          $.CurrentBranchId
    Set Global Variable           ${branchId}                   ${branchId}
    ${is_run_retail}              ${value}                      Run Keyword And Ignore Error     Should Contain      ${env}     zone
    ${run}                        Set Variable If               '${is_run_retail}' == 'PASS'     ${true}             ${false}
    Run Keyword If               '${run}'=='True'               Log                              RunRetail
    ...         ELSE              Run Fnb Or Booking                     ${resp.json()}
    Set Header
#########################################################################################################################################################
Run Fnb Or Booking
    [Arguments]                   ${resp_json}
    ${branchId}                   Get Value From Json KV        ${resp_json}          $.BranchId
    Set Suite Variable            ${branchId}                   ${branchId}
    Return From Keyword           ${branchId}
########################################################################################################################################################
Set Header
    ${branchId}                   Convert To String             ${branchId}
    ${header}                     Create Dictionary             retailer=${retailer}    Content-Type=application/json;charset=utf-8    branchid=${branchId}     Authorization=${token}
    ${headers_not_contenType}     Create Dictionary             retailer=${retailer}    branchid=${branchId}     Authorization=${token}
    Set Global Variable           ${header}                     ${header}
    Set Global Variable           ${headers_not_contenType}     ${headers_not_contenType}
    Create Session                session    ${url}             ${headers_not_contenType}
    Create Session                sessionMan                    ${url_man}              ${header}
    Set Global Variable           ${session}                    session
    Set Global Variable           ${session_man}                sessionMan
    ${name_branch}                Get Name Branch From Id       ${branchId}
