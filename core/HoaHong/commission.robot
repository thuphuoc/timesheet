***Settings***
Resource   share.robot
Resource   share_random.robot
***Variables***
${data_commission}            {"commission":{"id":[D0],"name":"[D1]","isAllBranch":true,"branchIds":[],"isActive":true}}
${enp_commission}             /commission
***Keywords***
Create Commission
    [Arguments]                 ${id}                                 ${name}                 ${status_code_expected}
    ${list_format}              Create List                           ${id}                   ${name}
    ${data_commission}          Format String Use [D0] [D1] [D2]      ${data_commission}      ${list_format}
    ${resp}                     Post Request Json KV                  ${session}              ${enp_commission}       ${data_commission}    ${status_code_expected}
    Return From Keyword         ${resp}

Get Random ID Commission
    ${id_commmission}           Get value in list KV    ${session}    ${enp_commission}                    $.result.data..id
    Return From Keyword         ${id_commmission}

Get Random Name Commission
    ${name_commmission}         Get value in list KV    ${session}    ${enp_commission}                    $.result.data..name
    Return From Keyword         ${name_commmission}

Update Commission
    ${id_commmission}     Get Random ID Commission
    ${list_format}        Create List                         ${id_commmission}             Update ${random_str}
    ${data_commission}    Format String Use [D0] [D1] [D2]    ${data_commission}     ${list_format}
    ${resp}               Update Request KV    ${session}     ${enp_commission}      ${data_commission}    200
    ${mess_expected}      Get Value From Json KV              ${resp}                $.message
    Should Be Equal       ${mess_expected}                      Cập nhật hoa hồng thành công

Delete Commission
    ${id_commmission}     Get Random ID Commission
    ${resp}               Delete Request KV    ${session}       ${enp_commission}/${id_commmission}                200
