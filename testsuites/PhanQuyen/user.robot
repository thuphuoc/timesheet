*** Settings ***
Library         JSONLibrary
Library         RequestsLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/BangChamCong/shift.robot
Suite setup     Fill enviroment and get token    ${env}
*** Variables ***
${enp_user}                 /users
${enp_role}                 /setting/roles?IncludePrivileges=true
${enp_user_branch}          /users?format=json&FromUsers=true&ExcludeMe=true&Includes=Permissions&%24inlinecount=allpages&BranchIds=[D0]&%24top=15&%24filter=IsActive+eq+true
${enp_add_perm_user}        /users/[D0]/privileges
${data_add_perm_user}        {"UserId":[D0],"BranchId":[D1],"RoleId":[D2],"Data":{"Campaign_Read":false,"Campaign_Update":false,"Campaign_Delete":false,"Invoice_Read":false,"Invoice_Create":false,"Invoice_Update":false,"Invoice_Delete":false,"Product_Read":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Invoice_Import":false,"Clocking_Copy":true,"Branch_Read":true,"Branch_Create":true,"Branch_Update":true,"Branch_Delete":true,"Campaign_Create":false,"Employee_Read":true,"Employee_Create":true,"Employee_Update":true,"Employee_Delete":true,"Clocking_Read":true,"Clocking_Create":true,"Clocking_Update":true,"Clocking_Delete":true,"Clocking_Export":true,"Clocking_SetupTimekeeping":true,"Shift_Read":true,"Shift_Create":true,"Shift_Update":true,"Shift_Delete":true},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":831796,"CompareGivenName":"userkm","CompareUserName":"userkm"}
${enp_update_user}          /users/usersupdate
${data_update_user}         {"User":{"Id":[D0],"IsActive":true,"GivenName":"[D1]","UserName":"[D2]","IsActiveStatus":"Đang hoạt động","LanguageSelected":{"Name":"vi-VN","Value":"Tiếng Việt"},"PlainPassword":"2","RetypePassword":"2"}}
*** TestCases ***
Format enp_user_branch      [Tags]       allretailer      allfnb     allbooking          permission
    ${list_format}          Create List                           ${branchId}
    ${enp_user_branch}      Format String Use [D0] [D1] [D2]      ${enp_user_branch}      ${list_format}
    Set Suite Variable      ${enp_user_branch}                    ${enp_user_branch}

Add permission timesheet      [Tags]    allretailer      allfnb                permission1
    [Documentation]         Thêm quyền timesheet cho user
    ${id_user}              Get Value In List KV                  ${session_man}          ${enp_user_branch}      $..Id
    ${name_user}            Get Name User                         ${id_user}
    Set Suite Variable      ${name_user}                          ${name_user}
    ${id_role}              Get Value In List KV                  ${session_man}          ${enp_role}             $..Id
    ${list_format_enp}      Create List                           ${id_user}
    ${enp_add_perm_user}    Format String Use [D0] [D1] [D2]      ${enp_add_perm_user}    ${list_format_enp}
    ${list_format}          Create List                           ${id_user}              ${branchId}             ${id_role}
    ${data_add_perm_user}   Format String Use [D0] [D1] [D2]      ${data_add_perm_user}                           ${list_format}
    ${resp}                 Post Request Json KV                  ${session_man}          ${enp_add_perm_user}    ${data_add_perm_user}    200
    ${resp}                 Update User For Login Auto By Use account                     ${id_user}

Add permission timesheet for booking      [Tags]          allbooking        permission
    [Documentation]         Thêm quyền timesheet cho user booking
    ${id_user}              Get Value In List KV                  ${session_man}          ${enp_user_branch}      $..Id
    ${name_user}            Get Name User                         ${id_user}
    Set Suite Variable      ${name_user}                          ${name_user}
    ${id_role}              Get Value In List KV                  ${session_man}          ${enp_role}             $..Id
    ${list_format_enp}      Create List                           ${id_user}
    ${enp_add_perm_user}    Format String Use [D0] [D1] [D2]      ${enp_add_perm_user}    ${list_format_enp}
    ${list_format}          Create List                           ${id_user}              ${branchId}             ${id_role}
    ${data_add_perm_user}   Format String Use [D0] [D1] [D2]      ${data_add_perm_user}                           ${list_format}
    ${resp}                 Post Request Json KV                  ${session_man}          ${enp_add_perm_user}    ${data_add_perm_user}    200
    ${resp}                 Update User For Login Auto By Use Account For Booking         ${id_user}

Login by user for add schedule work     [Tags]    allretailer      allfnb          allbooking     permission
    [Documentation]         Login bằng quyền user để chấm công cho nhân viên
    ${resp}                 Login By User                         ${name_user}             2
    ${resp}                 Create Shift                          123                      Auto${random_str}      ${branchId}             200

*** Keywords ***
Get Name User
    [Arguments]             ${id_user}
    ${name_user}            Get Value In List KV     ${session_man}     ${enp_user}/${id_user}    $.UserName
    Return From Keyword     ${name_user}

Update User For Login Auto By Use account
    [Arguments]             ${id_user}
    ${list_format}          Create List                           ${id_user}              ${name_user}           ${name_user}
    ${data_update_user}     Format String Use [D0] [D1] [D2]      ${data_update_user}     ${list_format}
    ${resp}                 Post Request Json KV                  ${session_man}          ${enp_update_user}      ${data_update_user}     200
    Return From Keyword     ${resp}

Update User For Login Auto By Use Account For Booking
    [Arguments]             ${id_user}
    ${list_format}          Create List                           ${id_user}              ${name_user}           ${name_user}
    ${data_update_user}     Format String Use [D0] [D1] [D2]      ${data_update_user}     ${list_format}
    ${resp}                 Post Request Json KV                  ${session_man}          ${enp_user}                 ${data_update_user}     200
    Return From Keyword     ${resp}
