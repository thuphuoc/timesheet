***Settings***
Library   JSONLibrary
Library  Collections
Resource  enviroment.robot
Suite setup  Fill enviroment and get token    zone12
***Keywords***
Format String Use [D0]
      [Arguments]    ${data_format}   ${list_format}
      ${length}  Get Length    ${list_format}
      :FOR  ${i}  IN RANGE  ${length}
      \     ${value_temp}   Get From List    ${list_format}    ${i}
      \     ${value_temp}   Convert To String    ${value_temp}
      \     ${data_format}   Replace String    ${data_format}    [D${i}]    ${value_temp}
      Return From Keyword   ${data_format}

Post Request Json
    [Arguments]   ${data_func}    ${firstname_data}   ${enpoint}    ${list_format}
    ${data}=    Evaluate     json.loads($data_func)    json
    Set To Dictionary   ${data["${firstname_data}"]}    Format String Use [D0]    ${data_func}    ${list_format}
    ${data_func} =    Evaluate    json.dumps($data)     json
    ${rep}  Post Request    ${session}    ${endpoint}    ${data_func}
    Should Be Equal As Strings    ${rep.status_code}     200

Get Value From Json KV
    [Arguments]     ${json}   ${json_path}
    ${result}   Get Value From Json    ${json}    ${json_path}
    ${lenght}   Get Length    ${result}
    ${result}   Get From List    ${result}    0
    Run Keyword If    ${lenght}==0     Return From Keyword    ${0}    ELSE   Return From Keyword   ${result}

Get id in list
    [Arguments]   ${enpoint}    ${json_path}
    ${resp}    Get Request   ${session}   ${enpoint}
    ${list_ID}   Get Value From Json KV    ${resp.json()}    ${json_path}
    ${ID}   Random in list      ${list_ID}
    Return From Keyword    ${ID}
