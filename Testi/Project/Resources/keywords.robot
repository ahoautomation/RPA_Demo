*** Settings ***

Library    SeleniumLibrary
Library    Pdf2TextLibrary
Library    String
Library    OperatingSystem
Library    DatabaseLibrary


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
  


Ajon Alustus
    Remove File    ${CURDIR}/Processed/*
    Remove File    ${CURDIR}/Not_Processed/*
    Alusta Tietokanta
    
Ajon Lopetus
    Disconnect From Database
    
Alusta Tietokanta
    Connect To Database    pymysql    example_database    robot    robot123    127.0.0.1     3306
    Execute SQL String    DROP TABLE IF EXISTS laskut;
    Execute SQL String    CREATE TABLE example_database.laskut (lasku_id INT AUTO_INCREMENT,tiedostonimi VARCHAR(255),summa DECIMAL(5,2),tila VARCHAR(255),PRIMARY KEY(lasku_id));

Prosessoi Validi Lasku
    [Arguments]    ${file}    ${summa}
    Copy File    ${CURDIR}/Incoming/${file}    ${CURDIR}/Processed/
    ${summa}    Replace String    ${summa}    ,    . 
    Execute SQL String    INSERT INTO `laskut` (`tiedostonimi`,`summa`,`tila`) VALUES('${file}',${summa},'OK');

Prosessoi Epävalidi Lasku
    [Arguments]    ${file}
    Copy File    ${CURDIR}/Incoming/${file}    ${CURDIR}/Not_Processed/
    Execute SQL String    INSERT INTO `laskut` (`tiedostonimi`,`summa`,`tila`) VALUES('${file}',Null,'Virhe!');
  