*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/ChiNhanh/branch.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
${name}          Chi nhanh
${phonenumber}    0368199698
${address}        so 1
*** TestCases ***
Create Branch    [Tags]     allretailer      allfnb          allbooking    branch
    [Documentation]       Thêm mới chi nhánh
    ${resp}               Create Branch    ${name} ${random_str}     ${phonenumber}     ${address}
    ${id_branch}          Get Value From Json KV                     ${resp}            $.Id

Update working date of branch        [Tags]     allretailer      allfnb          allbooking    branch
      [Documentation]       Update ngày làm việc của chi nhánh đang hoạt động
      ${resp}               Update working date of branch    Update ${random_str}       0    1   2    3    4   5
*** Keywords ***
