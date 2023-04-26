*** Settings ***
Documentation       Robo que faz ordens dos robos e salva em PDF os recibos e no final cria um arquivo Zip.


Library    RPA.Browser.Selenium
Library    RPA.Tables
Library    RPA.HTTP
Resource    Keywords//Keywords.robot

*** Tasks ***
Robo para Comprar robos
    Entrar no site e clicar no banner
    Download CSV
    ${compras}=    Ler tabela CSV
    Faz compra dos robos    ${compras}
    Zipar recibos
