***Settings***
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections
Library   String
Resource   share.robot
Resource   ../../core/6ChiNhanh/branch.robot
***Variables***
*** Keywords ***
Fill enviroment and get token
    [Arguments]                   ${env}
    ${dict_url_saleLogin}         Create Dictionary             zone5=https://testautots5.kiotviet.vn/api
    ...                                                         zone13=https://testautots13.kiotviet.vn/api
    ...                                                         zone12=https://testz12.kiotviet.vn/api
    ...                                                         zone14=https://testautots14.kiotviet.vn/api
    ...                                                         zone61=https://testz61.kiotviet.vn/api
    ...                                                         zone66=https://testz66.kiotviet.vn/api
    ...                                                         zone21=https://testz221.kiotviet.vn/api
    ...                                                         zone8=https://testz82.kiotviet.vn/api
    ...                                                         zone9=https://testautots9.kiotviet.vn/api
    ...                                                         zone1=https://testautots1.kiotviet.vn/api
    ...                                                         zone28=https://testz28.kiotviet.vn/api
    ...                                                         zone24=https://testzone24.kiotviet.vn/api
    ...                                                         zone59902=https://phuoc902.kvpos.com:59302/api
    ...                                                         zone59903=https://phuoc903.kvpos.com:59303/api
    ...                                                         fnb59508=https://phuoc59508.kvpos.com:59508/api
    ...                                                         booking9009=https://bookinghcm.kvpos.com:9009/api
    ...                                                         booking541=https://booking.kvpos.com:59541/api
    ...                                                         booking543=https://booking.kvpos.com:59543/api
    ...                                                         bookinglive=https://booking.kiotviet.vn/api
    ...                                                         fnb15=https://fnb.kiotviet.vn/api
    ...                                                         fnb15b=https://fnb.kiotviet.vn/api
    ...                                                         salon541=https://salon.kvpos.com:59541/api

    ${dict_enp_saleLogin}         Create Dictionary             zone5=/auth/salelogin
    ...                                                         zone13=/auth/salelogin
    ...                                                         zone12=/auth/salelogin
    ...                                                         zone1=/auth/salelogin
    ...                                                         zone14=/auth/salelogin
    ...                                                         zone61=/auth/salelogin
    ...                                                         zone66=/auth/salelogin
    ...                                                         zone21=/auth/salelogin
    ...                                                         zone24=/auth/salelogin
    ...                                                         zone28=/auth/salelogin
    ...                                                         zone8=/auth/salelogin
    ...                                                         zone9=/auth/salelogin
    ...                                                         zone59902=/auth/salelogin
    ...                                                         zone59903=/auth/salelogin
    ...                                                         fnb59508=/auth/salelogin
    ...                                                         booking9009=/auth/salelogin
    ...                                                         booking541=/auth/salelogin
    ...                                                         booking543=/auth/salelogin
    ...                                                         bookinglive=/auth/salelogin
    ...                                                         fnb15=/auth/salelogin
    ...                                                         fnb15b=/auth/salelogin
    ...                                                         salon541=/auth/salelogin

    ${dict_url}                   Create Dictionary             zone5=https://api-timesheet.kiotviet.vn
    ...                                                         zone13=https://api-timesheet.kiotviet.vn
    ...                                                         zone12=https://api-timesheet.kiotviet.vn
    ...                                                         zone1=https://api-timesheet.kiotviet.vn
    ...                                                         zone24=https://api-timesheet.kiotviet.vn
    ...                                                         zone28=https://api-timesheet.kiotviet.vn
    ...                                                         zone14=https://api-timesheet.kiotviet.vn
    ...                                                         zone61=https://api-timesheet.kiotviet.vn
    ...                                                         zone66=https://api-timesheet.kiotviet.vn
    ...                                                         zone21=https://api-timesheet.kiotviet.vn
    ...                                                         zone8=https://api-timesheet.kiotviet.vn
    ...                                                         zone9=https://api-timesheet.kiotviet.vn
    ...                                                         zone59902=https://kvpos.com:55002
    ...                                                         zone59903=https://kvpos.com:55003
    ...                                                         fnb59508=https://kvpos.com:55008
    ...                                                         booking9009=https://timesheetapi.kvpos.com:9009
    ...                                                         booking541=https://kvpos.com:55041
    ...                                                         booking543=https://kvpos.com:55043
    ...                                                         bookinglive=https://api-timesheet-booking.kiotviet.vn
    ...                                                         fnb15=https://api-fnbtimesheet.kiotviet.vn
    ...                                                         fnb15b=https://api-fnbtimesheet.kiotviet.vn
    ...                                                         salon541=https://kvpos.com:55041

    ${dict_url_man}               Create Dictionary             zone5=https://api-man.kiotviet.vn/api
    ...                                                         zone13=https://api-man.kiotviet.vn/api
    ...                                                         zone12=https://api-man.kiotviet.vn/api
    ...                                                         zone1=https://api-man.kiotviet.vn/api
    ...                                                         zone14=https://api-man.kiotviet.vn/api
    ...                                                         zone61=https://api-man3.kiotviet.vn/api
    ...                                                         zone66=https://api-man3.kiotviet.vn/api
    ...                                                         zone21=https://api-man3.kiotviet.vn/api
    ...                                                         zone24=https://api-man.kiotviet.vn/api
    ...                                                         zone28=https://api-man.kiotviet.vn/api
    ...                                                         zone8=https://api-man.kiotviet.vn/api
    ...                                                         zone9=https://api-man.kiotviet.vn/api
    ...                                                         zone59902=https://kvpos.com:59932/api
    ...                                                         zone59903=https://kvpos.com:59933/api
    ...                                                         fnb59508=https://kvpos.com:59508/api
    ...                                                         booking9009=https://bookinghcm.kvpos.com:9009/api
    ...                                                         booking541=https://booking.kvpos.com:59541/api
    ...                                                         booking543=https://booking.kvpos.com:59543/api
    ...                                                         bookinglive=https://booking.kiotviet.vn/api
    ...                                                         fnb15=https://fnb.kiotviet.vn/api
    ...                                                         fnb15b=https://fnb.kiotviet.vn/api
    ...                                                         salon541=https://salon.kvpos.com:59541/api

    ${dict_username}              Create Dictionary             zone5=admin             zone13=admin            zone12=admin        zone14=admin
    ...                                                         zone1=admin             zone9=admin             zone61=admin        zone21=admin    zone66=admin
    ...                                                         zone8=admin             zone24=admin            zone28=admin
    ...                                                         zone59902=1             zone59903=1             fnb59508=1
    ...                                                         booking9009=1           booking543=1            booking541=1        bookinglive=1       salon541=1
    ...                                                         fnb15=admin             fnb15b=admin
    ${dict_password}              Create Dictionary             zone5=123456            zone13=123456           zone12=123456       zone14=123456
    ...                                                         zone1=123456            zone9=123456            zone61=123456       zone21=123456
    ...                                                         zone8=123               zone24=123              zone28=123          zone66=123
    ...                                                         zone59902=1             zone59903=1             fnb59508=1
    ...                                                         booking9009=1           booking541=1            booking543=1        bookinglive=1       salon541=1
    ...                                                         fnb15=123               fnb15b=123
    ${dict_retailer}              Create Dictionary             zone5=testautots5       zone13=testautots13          zone12=testz12      zone14=testautots14
    ...                                                         zone1=testautots1       zone9=testautots9            zone61=testz61      zone21=testz221
    ...                                                         zone8=testz82           zone24=testzone24            zone28=testz28      zone66=testz66
    ...                                                         zone59902=phuoc902      zone59903=phuoc903      fnb59508=phuoc59508
    ...                                                         booking9009=phuoc009    booking543=phuoc443     booking541=phuocnew441      bookinglive=phuocliveb      salon541=phuoc441
    ...                                                         fnb15=testfnbz15a       fnb15b=testfnbz15b

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
    ${random_number}=             Random a Number               5
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
    Create Session                sessionman_not_contentType     ${url_man}              ${headers_not_contenType}
    Set Global Variable           ${session}                    session
    Set Global Variable           ${session_man}                sessionMan
    Set Global Variable           ${sessionman_not_contenType}                         sessionman_not_contentType
    ${name_branch}                Get Name Branch From Id       ${branchId}
########################################################################################################################################################
Login By User
    [Arguments]                   ${username}                   ${password}
    ${header}                     Create Dictionary             retailer=${retailer}    Content-Type=application/json;charset=utf-8
    ${data_saleLogin}             Create Dictionary             UserName=${username}    Password=${password}
    Create Session                sessionLogin                  ${url_saleLogin}
    ${resp}                       Post Request                  sessionLogin            ${enp_saleLogin}   headers=${header}     data=${data_saleLogin}
    Log                           ${resp.json()}
