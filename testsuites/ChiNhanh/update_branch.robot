*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/chinhanh/update_branch.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***

*** TestCases ***
Update working date of branch        [Tags]     all    branch
      [Documentation]       Update ngày làm việc của chi nhánh đang hoạt động
      ${resp}        Update working date of branch    Update ${random_str}    0    1   2    3    4   5
*** Keywords ***
