*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource   ../../core/Share/enviroment.robot
Resource  ../../core/Share/share.robot
Resource   ../../core/Share/share_random.robot
Resource   ../../core/5hoahong/commission.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
${value_update}         999
${is_update_all}        true
*** TestCases ***
Create commission               [Tags]                        allretailer      allfnb          allbooking                         commission
    [Documentation]             Thêm mới hoa hồng
    ${resp}                     Create Commission           170498                        ${random_str}             200
    ${id_commmission}           Get Value From Json KV      ${resp}                       $..id
    ${name_commmission}         Get Value From Json KV      ${resp}                       $..name
    Set Suite Variable          ${id_commmission}           ${id_commmission}
    Set Suite Variable          ${name_commmission}         ${name_commmission}

Create duplicate commission     [Tags]                       allretailer      allfnb          allbooking                          commission
    [Documentation]             Thêm mới hoa hồng trùng tên
    ${name}                     Get Random Name Commission
    ${resp}                     Create Commission           123456                       ${name}                 400
    Get Message Expected        ${resp}                     $.errors..message            Tên bảng hoa hồng đã tồn tại trên hệ thống

Create empty commission         [Tags]                       allretailer      allfnb          allbooking                          commission
    [Documentation]             Thêm mới hoa hồng rỗng
    ${resp}                     Create Commission           123456                       \ \                    400
    Get Message Expected        ${resp}                     $.errors..message            Bạn chưa nhập Tên bảng hoa hồng

Update commission               [Tags]                       allretailer      allfnb          allbooking                          commission
    [Documentation]             Cập nhật hoa hồng
    Update Commission

Add a product into commission   [Tags]                         allretailer      allfnb          allbooking                       commission
    [Documentation]             Tìm kiếm và thêm 1 hàng hóa vào bảng hoa hồng
    Log                         ${name_commmission}
    ${id_product}               Get RanDom a Product
    Set Suite Variable          ${id_product}                   ${id_product}
    ${code_product}             Get Code Product From ID                                 ${id_product}
    ${resp}                     Add Product Into Commission     ${id_commmission}        ${id_product}

Delete a product into commission   [Tags]          all         commission
    [Documentation]             Xóa 1 hàng hóa đã add vô bảng hoa hồng
    ${resp}                     Delete A Product Into Commission                        ${id_commmission}        ${id_product}

Add Category Of Product Into Commission    [Tags]                         allretailer      allfnb          allbooking            commission
    [Documentation]             Thêm nhóm hàng hóa vào bảng hoa hồng
    Log                         ${name_commmission}
    ${id_category}              Get Id Category Product
    ${name_category}            Get Name Category From Id                               ${id_category}
    ${resp}                     Add Category Of Product Into Commission                 ${id_commmission}    ${id_category}

Update The Roses For All Product        [Tags]                         allretailer      allfnb          allbooking               commission
    [Documentation]             Cập nhật TẤT CẢ mức áp dụng hoa hồng cho CÁC sản phẩm bán ra
    Log                         ${name_commmission}
    ${id_product}               Get Random a Product In a Commission                    ${id_commmission}
    ${code_product}             Get Code Product From ID    ${id_product}
    ${resp}                     Update The Roses For Each Product Sold  ${id_product}   ${id_commmission}        ${id_commmission}    ${value_update}    ${is_update_all}
    # Delete A Product Into Commission                                                    ${id_commmission}        ${id_product}

Update The Roses For A Product  [Tags]                         allretailer      allfnb          allbooking                       commission
    [Documentation]             Cập nhật mức áp dụng hoa hồng cho MỘT sản phẩm bán ra
    Log                         ${name_commmission}
    ${id_product}               Get Random a Product In a Commission                 ${id_commmission}
    ${code_product}             Get Code Product From ID    ${id_product}
    ${resp}                     Update The Roses For Each Product Sold               ${id_product}           ${id_commmission}         ${id_commmission}         777         false

Delete commission               [Tags]                         allretailer      allfnb          allbooking                      commission
    [Documentation]             Xóa hoa hồng
    ${id_commmission}           Get Random ID Commission
    Delete Commission           ${id_commmission}


*** Keywords ***
