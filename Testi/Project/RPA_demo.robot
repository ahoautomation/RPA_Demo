*** Settings ***

Resource    ./Resources/keywords.robot
Task Setup       Ajon Alustus
Task Teardown       Ajon Lopetus



*** Tasks ***

Laskujen käsittely
    Sleep    3s    #Lisätty viivettä, jotta demoa ehtii seurata silmämääräisesti
    ${files}    List Files In Directory    ${CURDIR}/Resources/Jarjestelma_A    # Haetaan käsiteltävien laskujen tiedostonimet muuttujaan  
    Log    ${files}
    FOR    ${file}    IN    @{files}    # Käsitellään jokainen lasku peräjälkeen
           Log To Console    Käsitellään tiedostoa ${file}
           ${summa}  Hae Laskun Summa    ${CURDIR}/Resources/Jarjestelma_A/${file}
           ${passed}    Run Keyword And Return Status    Should Match Regexp    ${summa}    \\d+,\\d+    # Tarkistetaan onnistuiko summan poimiminen laskulta 
           Run Keyword If	'${passed}' == 'True'	Käsittele Validi Lasku    ${file}    ${summa}    # Tallennetaan tieto onnistuneesta poiminnasta Järjestelmä Bn tietokantaan
           Run Keyword If	'${passed}' == 'False'	Käsittele Epävalidi Lasku    ${file}    # Tallennetaan tieto epäonnistuneesta poiminnasta Järjestelmä Bn tietokantaan
           Reload Page    # Päivitetään Järjestelmä Bn käyttöliittymä, jolloin päivittyneet tiedot haetaan tietokannasta
           Sleep    1s    # Lisätty viivettä, jotta demoa ehtii seurata silmämääräisesti
    END
      

   

   