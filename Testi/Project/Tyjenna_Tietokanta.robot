*** Settings ***
Resource    ./Resources/keywords.robot
Task Setup       Ajon Alustus
Task Teardown       Ajon Lopetus

*** Tasks ***
Tyhjennä Tietokanta
    [Documentation]    Tämä Taski ajaa Task Setupissa olevan Ajon alustus -avainsanan
    Log To Console    Tietokanta on tyhjennetty
