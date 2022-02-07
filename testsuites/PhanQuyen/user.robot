*** Settings ***
Library         JSONLibrary
Library         RequestsLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Suite setup     Fill enviroment and get token    ${env}
*** Variables ***
${enp_user}                 /users
${enp_role}                 /setting/roles?IncludePrivileges=true
${enp_user_branch}          /users?format=json&FromUsers=true&ExcludeMe=true&Includes=Permissions&%24inlinecount=allpages&BranchIds=[D0]&%24top=15&%24filter=IsActive+eq+true
${enp_add_perm_user}        /users/[D0]/privileges
${data_add_perm_user}        {"UserId":[D0],"BranchId":[D1],"RoleId":[D2],"Data":{"Campaign_Read":false,"Campaign_Update":false,"Campaign_Delete":false,"Invoice_Read":false,"Invoice_Create":false,"Invoice_Update":false,"Invoice_Delete":false,"Product_Read":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Invoice_Import":false,"Clocking_Copy":true,"Branch_Read":true,"Branch_Create":true,"Branch_Update":true,"Branch_Delete":true,"Campaign_Create":false,"Employee_Read":true,"Employee_Create":true,"Employee_Update":true,"Employee_Delete":true,"Clocking_Read":true,"Clocking_Create":true,"Clocking_Update":true,"Clocking_Delete":true,"Clocking_Export":true,"Clocking_SetupTimekeeping":true,"Shift_Read":true,"Shift_Create":true,"Shift_Update":true,"Shift_Delete":true},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":831796,"CompareGivenName":"userkm","CompareUserName":"userkm"}
*** TestCases ***
Format enp_user_branch      [Tags]       all     permission
    ${list_format}          Create List                           ${branchId}
    ${enp_user_branch}      Format String Use [D0] [D1] [D2]      ${enp_user_branch}      ${list_format}
    Set Suite Variable      ${enp_user_branch}                    ${enp_user_branch}

Add permission timesheet      [Tags]    all     permission
    [Documentation]         Thêm quyền timesheet cho user
    ${id_user}              Get value in list KV                  ${session_man}          ${enp_user_branch}      $..Id
    ${name_user}            Get Name User    ${id_user}
    ${id_role}              Get value in list KV                  ${session_man}          ${enp_role}             $..Id
    ${list_format_enp}      Create List                           ${id_user}
    ${enp_add_perm_user}    Format String Use [D0] [D1] [D2]      ${enp_add_perm_user}    ${list_format_enp}
    ${list_format}          Create List                           ${id_user}              ${branchId}             ${id_role}
    ${data_add_perm_user}   Format String Use [D0] [D1] [D2]      ${data_add_perm_user}                           ${list_format}
    ${resp}                 Post Request Json KV                  ${session_man}              ${enp_add_perm_user}    ${data_add_perm_user}    200
*** Keywords ***
Get Name User
    [Arguments]             ${id_user}
    ${name_user}            Get value in list KV     ${session_man}     ${enp_user}/${id_user}    $.UserName
    Return From Keyword     ${name_user}
