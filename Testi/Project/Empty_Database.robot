*** Settings ***

Resource    ./Resources/keywords.robot
Task Setup       Ajon Alustus
Task Teardown       Ajon Lopetus

*** Tasks ***

Tyhjennä Tietokanta
    Log To Console    Tietokanta on tyhjennetty
