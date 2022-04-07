*** Settings ***
Library         JSONLibrary
Library         RequestsLibrary
Resource   ../../core/Share/enviroment.robot
Resource  ../../core/Share/share.robot
Resource   ../../core/Share/share_random.robot
Resource   ../../core/BangTinhLuong/paysheet.robot
Resource   ../../core/NhanVien/employee.robot
Suite setup     Fill enviroment and get token    ${env}
*** Variables ***

*** TestCases ***
Add employee with fixed salary  [Tags]        allretailer      allfnb          allbooking    paysheet
     ${resp}                    Create Employee Fixed Salary       123456    NV${random_number}      NV co dinh                ${branchId}                         ${branchId}

Create paysheet                 [Tags]        allretailer      allfnb          allbooking    paysheet
     [Documentation]            Thêm mới bảng lương tạm tính
     ${resp}                    Create Paysheet

Auto loading paysheet           [Tags]        allretailer      allfnb          allbooking    paysheet
     [Documentation]            Tải lại bảng lương tạm tính
     ${resp}                    Auto Loading Paysheet

Payment Salary At Paysheet      [Tags]             allretailer      allfnb          allbooking              paysheet
      [Documentation]           Thanh toán phiếu lương ngoài màn hình bảng lương
      Format enpoint enp_filter_sheets                        1
      ${resp}                   Payment Salary At Paysheet

Cancel paysheet                 [Tags]             allretailer     allfnb                    allbooking                           paysheet
   [Documentation]             Huỷ bỏ bảng lương tạm tính ko hủy phiếu thanh toán
   ${resp}                     Cancel Paysheet

Delete employee                  [Tags]      allretailer      allfnb          allbooking         paysheet
     ${id_employee}              Get Random ID Employee
     ${resp}                     Delete Employee             ${id_employee}
