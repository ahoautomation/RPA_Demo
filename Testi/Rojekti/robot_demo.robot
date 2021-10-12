*** Settings ***

Library  SeleniumLibrary
Library  Pdf2TextLibrary
Library  String
*** Tasks ***



PDF

    ${teksti}  Hae Teksti PDF Tiedostosta    ${CURDIR}/Resources/DNA_lasku_1.pdf    Maksettava yhteensä EUR    Verokantaerittely
    Log    ${teksti}
    ${teksti}  Hae Teksti PDF Tiedostosta    ${CURDIR}/Resources/DNA_lasku_2.pdf    Maksettava yhteensä EUR    Verokantaerittely
    Log    ${teksti}
    ${teksti}  Hae Teksti PDF Tiedostosta    ${CURDIR}/Resources/DNA_lasku_3.pdf    Maksettava yhteensä EUR    Verokantaerittely
    Log    ${teksti}
    ${teksti}  Hae Teksti PDF Tiedostosta    ${CURDIR}/Resources/DNA_lasku_4.pdf    Maksettava yhteensä EUR    Verokantaerittely
    Log    ${teksti}


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