*** Settings ***

Resource    ./Resources/keywords.robot
Task Setup       Ajon Alustus
Task Teardown       Ajon Lopetus



*** Tasks ***

Laskujen käsittely
    Sleep    3s
    ${files}    List Files In Directory    ${CURDIR}/Resources/Incoming
    Log    ${files}
    FOR    ${file}    IN    @{files}
           Log To Console    Käsitellään tiedostoa ${file}
           ${summa}  Hae Teksti PDF Tiedostosta    ${CURDIR}/Resources/Incoming/${file}    Maksettava yhteensä EUR    Verokantaerittely
           Log    ${summa}
           ${passed}    Run Keyword And Return Status    Should Match Regexp    ${summa}    \\d+,\\d+
           Log    ${passed}
           Run Keyword If	'${passed}' == 'True'	Prosessoi Validi Lasku    ${file}    ${summa}
           Run Keyword If	'${passed}' == 'False'	Prosessoi Epävalidi Lasku    ${file}
           Reload Page
           Sleep    1s
    END
      

   

   