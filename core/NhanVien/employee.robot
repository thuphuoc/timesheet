***Settings***
Resource  ../../core/Share/share.robot
***Variables***
${enp_delete_work_schedule}       /timesheets/cancelTimeSheet
${data_del_work_schedule}         {"Id":[D0]}
${enp_employee}                   /employees
${data_employee}                  {"id":[D0],"code":"[D1]","name":"[D2]","branchId":[D3],"userId":null,"workBranchIds":[[D4]]}
***Keywords***
Get Random ID Employee
      ${id_employee}               Get Value In List KV    ${session}    ${enp_employee}                    $.result.data[?(@.id)].id
      ${code_employee}             Get Value In List KV    ${session}    ${enp_employee}/${id_employee}     $..code
      Return From Keyword          ${id_employee}
Create Employee And Get ID Employee

Delete work schedule
    [Arguments]                   ${id_work_schedule}
    ${list_format}                Create List                         ${id_work_schedule}
    ${data_del_work_schedule}     Format String Use [D0] [D1] [D2]    ${data_del_work_schedule}             ${list_format}
    ${resp}                       Update Request Json KV              ${session}                            ${enp_delete_work_schedule}   ${data_del_work_schedule}       200
    ${mess_validate}              Get Value From Json KV              ${resp}                               $.message
    Should Be Equal               ${mess_validate}                    Hủy lịch làm việc thành công
