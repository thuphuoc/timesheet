***Settings***
Resource  ../../core/Share/share.robot
Resource   ../../core/Share/share_random.robot
Resource   ../../core/Share/enviroment.robot
***Variables***
${data_commission}              {"commission":{"id":[D0],"name":"[D1]","isAllBranch":true,"branchIds":[],"isActive":true}}
${enp_commission}               /commission
# ${enp_category}                 /categories?IncludeProductNumber=true
${enp_add_category}             /commission-details/create-by-category
${data_add_category}            {"commissionIds":[D0],"productCategory":{"id":[D1]}}
${enp_product}                  /branchs/[D0]/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true&CategoryId=0&AttributeFilter=%5B%5D&ProductTypes=&IsImei=2&IsFormulas=2&IsActive=true&AllowSale=&IsBatchExpireControl=2&ShelvesIds=&TrademarkIds=&StockoutDate=alltime&supplierIds=&take=10&skip=0&page=1&pageSize=10&filter%5Blogic%5D=and
${enp_add_product}              /commission-details/create-by-product
${enp_del_product}              /commission-details/delete
${data_del_product}             {"commissionIds":[[D0]],"products":[{"id":[D1]}]}
${data_add_product}             {"commissionIds":[D0],"product":{"id":[D1]}}
${enp_product_sold}             /commission-details/update-value
${data_product_sold}            {"product":{"Id":[D0],"CommissionId":[D1]},"totalCommissionIds":[[D2]],"value":[D3],"valueRatio":null,"isUpdateForAllCommission":[D4]}
${enp_product_in_commission}    /products/get-time-sheet-product-commission?skip=0&take=10&OrderByDesc=CreatedDate&commissionIds=[D0]&includeInActive=true&includeSoftDelete=true
${enp_get_product}              /products
${enp_category}                 /categories
***Keywords***
Create Commission
    [Arguments]                 ${id}                                 ${name}                 ${status_code_expected}
    ${list_format}              Create List                           ${id}                   ${name}
    ${data_commission}          Format String Use [D0] [D1] [D2]      ${data_commission}      ${list_format}
    ${resp}                     Post Request Json KV                  ${session}              ${enp_commission}      ${data_commission}    ${status_code_expected}
    Return From Keyword         ${resp}
    ${id_commmission}           Get Value From Json KV                ${resp}                 $..id
    Set Suite Variable          ${id_commmission}                     ${id_commmission}

Get Random ID Commission
    ${id_commmission}           Get Value In List KV                  ${session}             ${enp_commission}      $.result.data..id
    Return From Keyword         ${id_commmission}

Get Id Category Product
    ${id_category}              Get Value In List KV                  ${session_man}        ${enp_category}         $..Id
    Get Name Category From Id   ${id_category}
    Return From Keyword         ${id_category}

Get Random Name Commission
    ${name_commmission}         Get Value In List KV                  ${session}            ${enp_commission}       $.result.data..name
    Return From Keyword         ${name_commmission}

Get Random a Product In a Commission
    [Arguments]                 ${id_commmission}
    ${list_format}              Create List                           ${id_commmission}
    ${enp_product_in_commission}    Format String Use [D0] [D1] [D2]  ${enp_product_in_commission}                  ${list_format}
    ${id_product}               Get Value In List KV                  ${session_man}        ${enp_product_in_commission}                    $..Id
    Return From Keyword         ${id_product}

Update Commission
    ${id_commmission}           Get Random ID Commission
    ${list_format}              Create List                          ${id_commmission}      Update ${random_str}
    ${data_commission}          Format String Use [D0] [D1] [D2]     ${data_commission}     ${list_format}
    ${resp}                     Update Request Json KV               ${session}             ${enp_commission}      ${data_commission}      200
    ${mess_expected}            Get Value From Json KV               ${resp}                $.message
    Should Be Equal             ${mess_expected}                     Cập nhật hoa hồng thành công

Get RanDom a Product
    ${list_format}              Create List                          ${branchId}
    ${enp_product}              Format String Use [D0] [D1] [D2]     ${enp_product}        ${list_format}
    ${id_product}               Get Value In List KV                 ${session_man}        ${enp_product}           $.Data[?(@.Id!=-1)]..Id
    Return From Keyword         ${id_product}

Get Code Product From ID
    [Arguments]                 ${id_product}
    ${code_product}             Get Value In List KV                ${session_man}          ${enp_get_product}/${id_product}                $.Code
    Return From Keyword         ${code_product}

Add Product Into Commission
    [Arguments]                 ${id_commmission}                   ${id_product}
    ${list_format}              Create List                         ${id_commmission}       ${id_product}
    ${data_add_product}         Format String Use [D0] [D1] [D2]    ${data_add_product}     ${list_format}
    ${resp}                     Post Request Json KV                ${session}              ${enp_add_product}    ${data_add_product}       200
    Return From Keyword         ${resp}

Delete A Product Into Commission
    [Arguments]                 ${id_commmission}                   ${id_product}
    ${list_format}              Create List                         ${id_commmission}       ${id_product}
    ${data_del_product}         Format String Use [D0] [D1] [D2]    ${data_del_product}     ${list_format}
    ${resp}                     Update Request Json KV              ${session}              ${enp_del_product}    ${data_del_product}       200
    Return From Keyword         ${resp}

Get Name Category From Id
    [Arguments]                 ${id_category}
    ${name_category}            Get Value In List KV                ${session_man}          ${enp_category}/${id_category}                  $..Name
    Return From Keyword         ${name_category}

Add Category Of Product Into Commission
    [Arguments]                 ${id_commmission}                   ${id_category}
    ${list_format}              Create List                         ${id_commmission}       ${id_category}
    ${data_add_category}        Format String Use [D0] [D1] [D2]    ${data_add_category}    ${list_format}
    ${name_category}            Get Name Category From Id           ${id_category}
    ${resp}                     Post Request Json KV                ${session}              ${enp_add_category}     ${data_add_category}    200

Update The Roses For Each Product Sold
    [Arguments]                 ${id_product}                       ${id_commmission}       ${id_commmission}       ${value}                ${is_update_all}
    ${list_format}              Create List                         ${id_product}           ${id_commmission}       ${id_commmission}       ${value}    ${is_update_all}
    ${data_product_sold}        Format String Use [D0] [D1] [D2]    ${data_product_sold}    ${list_format}
    ${resp}                     Update Request Json KV              ${session}              ${enp_product_sold}     ${data_product_sold}    200
    Return From Keyword         ${resp}

Delete Commission
    [Arguments]                 ${id_commmission}
    ${resp}                     Delete Request KV    ${session}     ${enp_commission}/${id_commmission}             200
