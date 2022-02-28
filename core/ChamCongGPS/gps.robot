*** Settings ***
Resource  ../../core/Share/share.robot
Resource   ../../core/Share/share_random.robot
Resource   ../../core/Share/enviroment.robot
Library      RequestsLibrary
*** Variables ***
${enp_gps}              /gpsinfos
${data_gps}             {"id":[D0],"branchId":[D1],"coordinate":"21.0379972,105.8187558","address":"[D2]","locationName":"Hà Nội - Quận Ba Đình","wardName":"Phường Liễu Giai","province":"Hà Nội ","district":" Quận Ba Đình","radiusLimit":"[D3]"}
${enp_change_qr}        /gpsinfos/changeQrKey
*** Keywords ***
Get A GPS In List GPS
    ${id_gps}              Get Value In List KV            ${session}          ${enp_gps}          $..id
    Return From Keyword    ${id_gps}

Get List Branch Had Used GPS
    ${resp}                Get Request From KV             ${session}          ${enp_gps}
    Return From Keyword    ${resp}

Create GPS
    [Arguments]         ${id_gps}                           ${id_branch}        ${address}           ${radiusLimit}
    ${list_format}      Create List                         ${id_gps}           ${id_branch}         ${address}             ${radiusLimit}
    ${data_gps}         Format String Use [D0] [D1] [D2]    ${data_gps}         ${list_format}
    ${data_gps}         Evaluate                            (None,'${data_gps}')
    ${formdata}         Create Dictionary                   gpsInfo=${data_gps}
    ${resp}             Post Request Use Formdata KV        ${session}          ${enp_gps}           ${formdata}            200
    Return From Keyword    ${resp}

Update GPS
    [Arguments]         ${id_gps}                           ${id_branch}        ${address_up}        ${radiusLimit}
    ${list_format}      Create List                         ${id_gps}           ${id_branch}         ${address_up}          ${radiusLimit}
    ${data_gps}         Format String Use [D0] [D1] [D2]    ${data_gps}         ${list_format}
    ${data_gps}         Evaluate                            (None,'${data_gps}')
    ${formdata}         Create Dictionary                   gpsInfo=${data_gps}
    ${resp}             Update Request Json KV Use Formdata KV                  ${session}          ${enp_gps}/${id_gps}              ${formdata}            200
    Return From Keyword    ${resp}

Change QR
    [Arguments]         ${id_gps}
    ${list_format}      Create List                         ${id_gps}
    ${enp_change_qr}    Format String Use [D0] [D1] [D2]    ${enp_change_qr}    ${list_format}
    ${resp}             Put Request                         ${session}          ${enp_change_qr}/${id_gps}
    Return From Keyword                                     ${resp.json()}

Delete GPS
    [Arguments]         ${id_gps}
    ${resp}             Delete Request KV                  ${session}          ${enp_gps}/${id_gps}        200
    Return From Keyword                                    ${resp}
