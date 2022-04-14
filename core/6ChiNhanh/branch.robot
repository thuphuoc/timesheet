*** Settings ***
Library   JSONLibrary
Library   Collections
Library   RequestsLibrary
Resource  ../../core/Share/share.robot
Resource   ../../core/Share/share_random.robot
Resource   ../../core/Share/enviroment.robot
*** Variables ***
${enp_branch_active}            /branchs?format=json&Includes=Permissions&Includes=Retailer&$inlinecount=allpages&$top=15&$filter=LimitAccess+eq+false
${enp_branch}                   /branchs
${data_update_workingdate}      {"Branch":{"Id":[D0],"Name":"[D1]","Address":"123","ContactNumber":"0376666666","IsActive":true,"LocationName":"Bà Rịa - Vũng Tàu - Huyện Long Điền","WardName":"Xã Phước Hưng"},"BranchSetting":{"workingDays":[[D2],[D3],[D4],[D5],[D6],[D7]]},"IsAddMore":false,"IsRemove":false,"ApplyFrom":"2022-01-27T08:37:51.164Z"}
${data_create_branch}           {"Branch":{"Name":"[D0]","ContactNumber":"[D1]","Address":"[D2]","LocationName":"Hồ Chí Minh - Thành phố Thủ Đức","WardName":"Phường An Khánh"},"BranchSetting":{"workingDays":[1,2,3,4,5,6]}}
${enp_delete_branch}            /branchs?Id=[D0]

*** Keywords ***
Get List Of Active Branch
    ${resp}                     Get Request From KV     ${session_man}       ${enp_branch_active}
    Return From Keyword         ${resp}

Get A Branch In Active Branchs
    ${id_branch}                Get Value In List KV    ${session_man}       ${enp_branch_active}      $.Data[?(@.Id)].Id
    Return From Keyword         ${id_branch}

Get Name Branch From Id
    [Arguments]                 ${branchId}
    ${resp}                     Get Request               ${session_man}     ${enp_branch}/${branchId}
    Log                         ${resp.json()}
    ${name}                     Get Value From Json       ${resp.json()}     $.Name
    Return From Keyword         ${name}

Create Branch
    [Arguments]                 ${name}                 ${phonenumber}       ${address}
    ${list_format}              Create List             ${name}              ${phonenumber}            ${address}
    ${data_create_branch}       Format String Use [D0] [D1] [D2]             ${data_create_branch}     ${list_format}
    ${resp}                     Post Request            ${session_man}       ${enp_branch}             ${data_create_branch}
    Log                         ${resp.json()}
    ${resp.status_code}         Convert To String       ${resp.status_code}
    ${status_check_brach}=      Evaluate                ${resp.status_code}
    Return From Keyword         ${status_check_brach}

Update working date of branch
    [Arguments]                 ${name}                 ${date1}            ${date2}                   ${date3}                 ${date4}     ${date5}      ${date6}
    ${id}                       Get A Branch In Active Branchs
    ${name_from_id}             Get Name Branch From Id    ${id}
    ${list_format}              Create List                ${id}            ${name}                     ${date1}                ${date2}     ${date3}       ${date4}    ${date5}    ${date6}
    ${data_update_workingdate}  Format String Use [D0] [D1] [D2]            ${data_update_workingdate}  ${list_format}
    ${resp}                     Post Request Json KV       ${session_man}   ${enp_branch}               ${data_update_workingdate}           200
    Return From Keyword         ${resp}

Delete Branch
    [Arguments]                 ${id_branch}
    ${list_format}              Create List                                  ${id_branch}
    ${enp_delete_branch}        Format String Use [D0] [D1] [D2]             ${enp_delete_branch}       ${list_format}
    ${resp}                     Delete Request                               ${sessionman_not_contenType}             ${enp_delete_branch}
    Log                         ${resp.json()}
    ${resp.status_code}         Convert To String                            ${resp.status_code}
    ${status_check_brach}=      Evaluate                                     ${resp.status_code}
