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
Suite Teardown  Delete Allowance of Employee
*** TestCases ***
Create payRateTemplate      [Tags]               all      payrate
    [Documentation]         Tạo mới mẫu lương có chứa phụ cấp, giảm trừ, hoa hồng
    ${id_allowance}         Get Random ID Allowance
    ${id_deduction}         Get Random ID Deduction
    ${resp}                 Create PayRateTemplate      ${id_Allowance}     ${id_Deduction}
    ${id_payrate}           Get Value From Json KV      ${resp}             $..id
    Set Suite Variable      ${id_payrate}               ${id_payrate}

Update payRateTemplate      [Tags]               all      payrate
    [Documentation]         Update mẫu lương
    ${id_payrate}           Get ID And Name PayRateTemplate
    ${id_allowance}         Get Random ID Allowance
    ${id_deduction}         Get Random ID Deduction
    ${resp}                 Update PayRateTemplate  ${id_payrate}  Update ${random_str}    ${id_allowance}    ${id_deduction}

Delete payrateTemplate      [Tags]               all      payrate
    [Documentation]         Xóa mẫu lương vừa tạo
    Delete PayRateTemplate    ${id_payrate}
*** Keywords ***
Delete Allowance of Employee
    Delete Allowance
