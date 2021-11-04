*** Settings ***
Resource    ./Resources/keywords.robot

Library    SeleniumLibrary
Library    Pdf2TextLibrary
Library    String
Library    OperatingSystem
Library    DatabaseLibrary
Suite Setup       Ajon Alustus
Suite Teardown       Ajon Lopetus



*** Tasks ***



Laskujen käsittely
    Sleep    3s
    ${files}    List Files In Directory    ${CURDIR}/Resources/Incoming
    Log    ${files}
    FOR    ${file}    IN    @{files}
           ${summa}  Hae Teksti PDF Tiedostosta    ${CURDIR}/Resources/Incoming/${file}    Maksettava yhteensä EUR    Verokantaerittely
           Log    ${summa}
           ${passed}    Run Keyword And Return Status    Should Match Regexp    ${summa}    \\d+,\\d+
           Log    ${passed}
           Run Keyword If	'${passed}' == 'True'	Prosessoi Validi Lasku    ${file}    ${summa}
           Run Keyword If	'${passed}' == 'False'	Prosessoi Epävalidi Lasku    ${file}
           Sleep    1s
    END
      

   

   