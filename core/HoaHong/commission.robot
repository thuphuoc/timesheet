***Settings***
Resource  ../../core/share/share.robot
Resource   ../../core/share/share_random.robot
Resource   ../../core/share/enviroment.robot
***Variables***
${data_commission}            {"commission":{"id":[D0],"name":"[D1]","isAllBranch":true,"branchIds":[],"isActive":true}}
${enp_commission}             /commission
${enp_category}               /categories?IncludeProductNumber=true
${enp_add_category}           /commission-details/create-by-category
${data_add_category}          {"commissionIds":[D0],"productCategory":{"id":[D1]}}
***Keywords***
Create Commission
    [Arguments]                 ${id}                                 ${name}                 ${status_code_expected}
    ${list_format}              Create List                           ${id}                   ${name}
    ${data_commission}          Format String Use [D0] [D1] [D2]      ${data_commission}      ${list_format}
    ${resp}                     Post Request Json KV                  ${session}              ${enp_commission}       ${data_commission}    ${status_code_expected}
    Return From Keyword         ${resp}
    ${id_commmission}           Get Value From Json KV                ${resp}                 $..id
    Set Suite Variable          ${id_commmission}                     ${id_commmission}

Get Random ID Commission
    ${id_commmission}           Get value in list KV    ${session}    ${enp_commission}                    $.result.data..id
    Return From Keyword         ${id_commmission}

Get Id Category Product
    ${id_category}              Get value in list KV    ${session_man}    ${enp_category}       $..Id
    Return From Keyword         ${id_category}

Get Random Name Commission
    ${name_commmission}         Get value in list KV    ${session}    ${enp_commission}                    $.result.data..name
    Return From Keyword         ${name_commmission}

Update Commission
    ${id_commmission}     Get Random ID Commission
    ${list_format}        Create List                         ${id_commmission}      Update ${random_str}
    ${data_commission}    Format String Use [D0] [D1] [D2]    ${data_commission}     ${list_format}
    ${resp}               Update Request KV    ${session}     ${enp_commission}      ${data_commission}    200
    ${mess_expected}      Get Value From Json KV              ${resp}                $.message
    Should Be Equal       ${mess_expected}                    Cập nhật hoa hồng thành công

Add Category Of Product Into Commission
    [Arguments]           ${id_commmission}                   ${id_category}
    ${list_format}        Create List                         ${id_commmission}     ${id_category}
    ${data_add_category}  Format String Use [D0] [D1] [D2]    ${data_add_category}  ${list_format}
    ${resp}               Post Request Json KV    ${session}  ${enp_add_category}   ${data_add_category}    200
Delete Commission
    [Arguments]           ${id_commmission}
    ${resp}               Delete Request KV    ${session}       ${enp_commission}/${id_commmission}                200
