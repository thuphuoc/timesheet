*** Settings ***
Resource   ../../core/Share/enviroment.robot
Resource  ../../core/Share/share.robot
Resource   ../../core/Share/share_random.robot
Resource   ../../core/5HoaHong/commission.robot
Suite setup  Fill enviroment and get token    ${env}
*** Variables ***
${data_add_categories}          {"Category":{"Name":"[D0]"}}
${enp_add_catagories}           /categories
${enp_add_product}              /products/addmany
${data_add_product}             [{"ProductType":2,"CategoryId":[D0],"isActive":false,"AllowsSale":true,"isDeleted":false,"Code":"","BasePrice":200000,"Cost":100000,"OnHand":250,"ConversionValue":1,"Name":"[D1]"}]
${enp_del_product}              /products
*** TestCases ***
Add categories                  [Tags]              allretailer    allfnb       allbooking    categories
    ${list_format}              Create List                               Nhom ${random_str}
    ${data_add_categories}      Format String Use [D0] [D1] [D2]          ${data_add_categories}    ${list_format}
    ${resp}                     Post Request Json KV    ${session_man}    ${enp_add_catagories}     ${data_add_categories}    200

Add product                     [Tags]              allretailer    allfnb       allbooking    product
    ${id_category}              Get Id Category Product
    ${list_format}              Create List                               ${id_category}            HangTS ${random_str}
    ${data_add_product}         Format String Use [D0] [D1] [D2]          ${data_add_product}       ${list_format}
    ${data_add_product}         Evaluate                                  (None,'${data_add_product}')
    ${formdata}                 Create Dictionary                         ListProducts=${data_add_product}
    Log                         ${formdata}
    ${resp}                     Post Request Use Formdata KV              ${sessionman_not_contenType}            ${enp_add_product}               ${formdata}            200

# Delete product                  [Tags]              allretailer    allfnb       allbooking    product
#     ${id_product}               Get RanDom a Product
#     ${resp}                     Delete Request KV                        ${sessionman_not_contenType}                           ${enp_del_product}/${id_product}    200
*** Keywords ***
