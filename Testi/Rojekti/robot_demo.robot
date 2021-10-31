*** Settings ***

Library  SeleniumLibrary
Library  Pdf2TextLibrary
Library  String
Library  OperatingSystem

Suite Setup       Alusta Ajo
*** Tasks ***



PDF
    ${files}    List Files In Directory    ${CURDIR}/Resources/Incoming
    Log    ${files}
    FOR    ${file}    IN    @{files}
           ${teksti}  Hae Teksti PDF Tiedostosta    ${CURDIR}/Resources/Incoming/${file}    Maksettava yhteensä EUR    Verokantaerittely
           Log    ${teksti}
           
            ${passed}    Run Keyword And Return Status    Should Match Regexp    ${teksti}	\\d+,\\d+
           Log    ${passed}
           Run Keyword If	'${passed}' == 'True'	Copy File    ${CURDIR}/Resources/Incoming/${file}    ${CURDIR}/Resources/Processed/
           Run Keyword If	'${passed}' == 'False'	Copy File    ${CURDIR}/Resources/Incoming/${file}    ${CURDIR}/Resources/Not_Processed/

    END


*** Keywords ***




Hae Teksti väliltä
    [Arguments]    ${teksti}    ${alku}    ${loppu}
    ${teksti}    Fetch From Right    ${teksti}    ${alku}
    ${teksti}    Fetch From Left    ${teksti}    ${loppu}
    ${teksti}    Strip string    ${teksti}
    [return]    ${teksti}

Hae Teksti PDF Tiedostosta
    [Arguments]    ${polku_pdf_tiedotoon}    ${alku}    ${loppu}
    ${apu}    ${teksti}    Run Keyword And Ignore Error    Convert Pdf To Txt    ${polku_pdf_tiedotoon}
    Return From Keyword If    '${apu}'=='FAIL'    ${EMPTY}
    Log    ${teksti}
    ${apu}    ${teksti}    Run Keyword And Ignore Error    Hae Teksti väliltä    ${teksti}    Maksettava yhteensä EUR    Verokantaerittely
    Return From Keyword If    '${apu}'=='FAIL'    ${EMPTY}
    [return]    ${teksti}
    

Alusta Ajo
    Remove File    ${CURDIR}/Resources/Processed/*
    Remove File    ${CURDIR}/Resources/Not_Processed/*
