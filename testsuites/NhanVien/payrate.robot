*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Library  DependencyLibrary
Resource        ../../core/share/enviroment.robot
Resource        ../../core/share/share.robot
Resource        ../../core/share/share_random.robot
Resource        ../../core/nhanvien/allowance.robot
Resource        ../../core/nhanvien/deduction.robot
Resource        ../../core/nhanvien/payrate.robot
Suite setup     Fill enviroment and get token    ${env}
Suite Teardown  Phuoc
*** TestCases ***
Create payRateTemplate      [Tags]               all      payrate
    [Documentation]         Tạo mới mẫu lương có chứa phụ cấp, giảm trừ, hoa hồng
    ${id_Allowance}         Get Random ID Allowance
    ${id_Deduction}         Get Random ID Deduction
    ${resp}                 Create PayRateTemplate      ${id_Allowance}     ${id_Deduction}
    
Update payRateTemplate      [Tags]               all      payrate
    [Documentation]         Update mẫu lương
*** Keywords ***
Phuoc
    Delete Allowance
