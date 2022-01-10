*** Settings ***
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../core/enviroment.robot
Resource   ../core/share.robot
Resource   ../core/share_random.robot
Suite setup  Fill enviroment and get token    ${env}

*** Variables ***
${data_shift}   {"shift":{"name":"[D0]","from":420,"to":660,"isActive":true,"branchId":[D1],"checkInBefore":240,"checkOutAfter":840}}
${enp_shift}    /shifts

*** TestCases ***
Create shift
    Post Request Json KV    ${session}    ${enp_shift}     data_func    expected_status_code
Update shift
Delete shift

*** Keywords ***
