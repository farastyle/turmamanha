*** Settings ***
Documentation       Robo que faz ordens dos robos e salva em PDF os recibos e no final cria um arquivo Zip.


Library    RPA.Browser.Selenium
Library    RPA.Tables
Library    RPA.HTTP
Library    RPA.PDF
Library    RPA.Archive
Resource    Keywords//Keywords.robot

*** Keywords ***
Entrar no site e clicar no banner
    [Arguments]    ${link}=https://robotsparebinindustries.com/#/robot-order
    Open Available Browser    ${link}
    
Download CSV
    Download    https://robotsparebinindustries.com/orders.csv
Ler tabela CSV
    ${compras}=    Read table from CSV    ${EXECDIR}//orders.csv  header=${TRUE}
    [Return]    ${compras}
Preencher formulario pra um robo
    [Arguments]    ${compra}
    Click Element When Visible    //button[.='OK']
    Select From List By Value    head   ${compra}[Head]
    Select Radio Button    body    ${compra}[Body]
    Input Text    css:input[placeholder='Enter the part number for the legs']    ${compra}[Legs]
    Input Text    address    ${compra}[Address]
    Click Element    //button[@id='preview']
    Click Element    order
    
    ${ERRO}=  Is Element Visible    css:button[id="order-another"]
    WHILE    ${ERRO} == ${FALSE}
        Click Element    order
        ${ERRO}=  Is Element Visible    css:button[id="order-another"]
    END
    
    #CRIACAO DO PDF
    ${reciept_data}=  Get Element Attribute  //div[@id="receipt"]  outerHTML
    Html To Pdf  ${reciept_data}  ${CURDIR}${/}reciepts${/}${compra}[Order number].pdf
    Screenshot  //div[@id="robot-preview-image"]  ${CURDIR}${/}robots${/}${compra}[Order number].png 
    Add Watermark Image To Pdf  ${CURDIR}${/}robots${/}${compra}[Order number].png  ${CURDIR}${/}reciepts${/}${compra}[Order number].pdf  ${CURDIR}${/}reciepts${/}${compra}[Order number].pdf 
    Click Button  //button[@id="order-another"]
    
    
Faz compra dos robos
    [Arguments]    ${compras}
    FOR  ${compra}    IN    @{compras}
        Preencher formulario pra um robo    ${compra}
    END

Zipar recibos
    Archive Folder With Zip  ${CURDIR}${/}reciepts  ${OUTPUT_DIR}${/}reciepts.zip