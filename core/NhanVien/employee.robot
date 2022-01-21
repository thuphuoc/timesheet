***Settings***
Resource   share.robot
Resource   share_random.robot
***Variables***
${enp_employee}                   /employees
${data_employee}                  {"id":[D0],"code":"[D1]","name":"[D2]","branchId":[D3],"userId":null,"workBranchIds":[[D4]]}
***Keywords***
Get Random ID Employee
      ${id_employee}               Get value in list KV    ${session}    ${enp_employee}        $.result.data[?(@.id)].id
      Return From Keyword          ${id_employee}

Get Name Employee By Id
      [Arguments]                  ${id_employee}
      ${name}                      Get Request from KV     ${session}    ${enp_employee}/${id_employee}
      Return From Keyword          ${name}
