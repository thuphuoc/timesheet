*** Settings ***
Resource  ../../core/share/share.robot
Resource   ../../core/share/share_random.robot
*** Variables ***
${enp_branch_active}        /branchs?format=json&Includes=Permissions&Includes=Retailer&$inlinecount=allpages&$top=15&$filter=LimitAccess+eq+false
${enp_branch}               /branchs
${data_update_workingdate}     {"Branch":{"Id":[D0],"Name":"[D1]","Address":"123","ContactNumber":"0376666666","IsActive":true,"LocationName":"Bà Rịa - Vũng Tàu - Huyện Long Điền","WardName":"Xã Phước Hưng"},"BranchSetting":{"workingDays":[[D2],[D3],[D4],[D5],[D6],[D7]]},"IsAddMore":false,"IsRemove":false,"ApplyFrom":"2022-01-27T08:37:51.164Z"}
*** Keywords ***
Get list of active branch
    ${resp}    Get Request from KV    ${session_man}    ${enp_branch_active}
    Return From Keyword    ${resp.json()}

Get a branch in active branchs
    ${id}     Get value in list KV    ${session_man}    ${enp_branch_active}      $.Data[?(@.Id)].Id
    Return From Keyword   ${id}

Get name branch from id
    ${id}     Get a branch in active branchs
    ${name}     Get value in list KV   ${session_man}    ${enp_branch}/${id}    $.Name
    Return From Keyword    ${name}

Update working date of branch
    [Arguments]       ${name}    ${date1}      ${date2}     ${date3}     ${date4}     ${date5}            ${date6}
    ${id}             Get a branch in active branchs
    ${name_from_id}   Get name branch from id
    ${list_format}    Create List               ${id}       ${name}       ${date1}    ${date2}            ${date3}       ${date4}    ${date5}    ${date6}
    ${data_update_workingdate}     Format String Use [D0] [D1] [D2]       ${data_update_workingdate}      ${list_format}
    ${resp}   Post Request Json KV    ${session_man}    ${enp_branch}      ${data_update_workingdate}     200
    Return From Keyword    ${resp}
