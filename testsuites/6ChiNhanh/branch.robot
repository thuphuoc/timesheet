*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/6ChiNhanh/branch.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
${phonenumber}    0368199698
${address}        so 1
*** TestCases ***
Create Branch    [Tags]     allretailer      allfnb          allbooking    branch
    [Documentation]       Thêm mới chi nhánh
    ${id_branch}           Get A Branch In Active Branchs
    ${resp}                Create Branch     Chi nhánh ${random_str}     ${phonenumber}     ${address}
    Run Keyword If         ${resp}==420                        Delete Branch      ${id_branch}

Update working date of branch        [Tags]     allretailer      allfnb          allbooking    branch
      [Documentation]       Update ngày làm việc của chi nhánh đang hoạt động
      ${resp}               Update working date of branch    Update ${random_str}       0    1   2    3    4   5

*** Keywords ***
