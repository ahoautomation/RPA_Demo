*** Settings ***

Library    String             # Robotin sisäinen kirjasto tekstijonojen käsittelyyn
Library    OperatingSystem    # Robotin sisäinen kirjasto tiedostojen käsittelyyn
Library    SeleniumLibrary    # Ulkoinen kirjasto selaimen hallintaa varten
Library    Pdf2TextLibrary    # Ulkoinen kirjasto tekstin lukuun PDF-tiedostosta
Library    DatabaseLibrary    # Ulkoinen kirjasto tietokantojen käsittelyyn

*** Keywords ***

Hae Teksti väliltä
    [Documentation]    Palauttaa kahden merkkijonon väliin jäävän merkkijonon
    [Arguments]    ${teksti}    ${alku}    ${loppu}
    ${teksti}    Fetch From Right    ${teksti}    ${alku}
    ${teksti}    Fetch From Left    ${teksti}    ${loppu}
    ${teksti}    Strip string    ${teksti}
    [return]    ${teksti}

Hae Laskun Summa
    [Documentation]    Lukee PDF-muotoisen laskun tekstisisällön ja poimii siitä laskun summan
    [Arguments]    ${polku_pdf_tiedotoon}
    ${apu}    ${teksti}    Run Keyword And Ignore Error    Convert Pdf To Txt    ${polku_pdf_tiedotoon}    # Poimii PDF-tiedoston tekstisisällön
    Return From Keyword If    '${apu}'=='FAIL'    ${EMPTY}    # Jos yllä oleva tekstin poiminta epäonnistuu, niin palautetaan tyhjä
    Log    ${teksti}
    ${apu}    ${summa}    Run Keyword And Ignore Error    Hae Teksti väliltä    ${teksti}    Maksettava yhteensä EUR    Verokantaerittely
    Return From Keyword If    '${apu}'=='FAIL'    ${EMPTY}    # Jos yllä oleva tekstihaku ei löydä oletettua laskun summaa, niin palautetaan tyhjä
    [return]    ${summa}

Ajon Alustus
    [Documentation]    Demossa ajoympäristö vakioidaan odotetunlaiseen tilaan, ennen vaisinaisen Taskin ajoa
    Close All Browsers
    Remove File    ${CURDIR}/Kasitellyt_laskut/*
    Remove File    ${CURDIR}/Epaonnistuneet_laskut/*
    Alusta Järjestelmä Bn Tietokanta
    Open Browser	http://localhost    FireFox    # Avataan Järjestelmä Bn käyttöliittymä
    Log To console    ${EMPTY}
    
Ajon Lopetus
    [Documentation]    Kun ajo lopetetaan tulee roikkumaan jääneet tietokantayhteydet katkaista.
    Disconnect From Database
    
Alusta Järjestelmä Bn Tietokanta
    [Documentation]    Jotta, demon voi ajaa uudelleen alusta asti, tulee tietokannan tila palauttaa alkutilaansa
    Connect To Database    pymysql    example_database    robot    robot123    127.0.0.1     3306
    Execute SQL String    DROP TABLE IF EXISTS laskut;
    Execute SQL String    CREATE TABLE example_database.laskut (lasku_id INT AUTO_INCREMENT,tiedostonimi VARCHAR(255),summa DECIMAL(5,2),tila VARCHAR(255),PRIMARY KEY(lasku_id));

Käsittele Validi Lasku
    [Documentation]    Tallentaa tiedon prosessoinnin onnistumisesta Järjestelmä Bn tietokantaan (tila=OK)
    [Arguments]    ${file}    ${summa}
    Copy File    ${CURDIR}/Jarjestelma_A/${file}    ${CURDIR}/Kasitellyt_laskut/
    ${summa}    Replace String    ${summa}    ,    . 
    Execute SQL String    INSERT INTO `laskut` (`tiedostonimi`,`summa`,`tila`) VALUES('${file}',${summa},'OK');

Käsittele Epävalidi Lasku
    [Documentation]    Tallentaa tiedon prosessoinnin epäonnistumisesta Järjestelmä Bn tietokantaan  (tila=Virhe!)
    [Arguments]    ${file}
    Copy File    ${CURDIR}/Jarjestelma_A/${file}    ${CURDIR}/Epaonnistuneet_laskut/
    Execute SQL String    INSERT INTO `laskut` (`tiedostonimi`,`summa`,`tila`) VALUES('${file}',Null,'Virhe!');
  