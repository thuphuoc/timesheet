*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library  Collections

*** Variables ***
${enp_payrate}
${data_payrate}            {"payRateTemplate":{"name":"[D0]","salaryPeriod":1,"commissionSalaryRuleValue":{"commissionSalaryRuleValueDetails":[{"commissionLevel":30000,"commissionTableId":20000000000845}],"type":2,"formalityTypes":0,"branchIds":[]},"allowanceRuleValue":{"allowanceRuleValueDetails":[{"allowanceId":210000001105402,"value":10000,"type":0,"isChecked":true}]},"deductionRuleValue":{"deductionRuleValueDetails":[{"deductionId":170000000119202,"value":15000,"type":0,"deductionRuleId":2,"deductionTypeId":1,"blockTypeTimeValue":1,"blockTypeMinuteValue":1}]}},"branchId":302728}
*** TestCases ***

*** Keywords ***
