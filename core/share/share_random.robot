***Settings***
Library   JSONLibrary
Library  Collections
Library  String
***Keywords***
Random a Number
    [Arguments]             ${number}
    ${random_number} =      Generate Random String  ${number}   [NUMBERS]
    Return From Keyword     ${random_number}

Random a String lower
    [Arguments]             ${number}
    ${random_str}=          Generate Random String  ${number}   [LOWER]
    Return From Keyword     ${random_str}

Random a String Letter
    [Arguments]             ${number}
    ${random_str}=          Generate Random String  ${number}   [LETTERS]
    Return From Keyword    ${random_str}
