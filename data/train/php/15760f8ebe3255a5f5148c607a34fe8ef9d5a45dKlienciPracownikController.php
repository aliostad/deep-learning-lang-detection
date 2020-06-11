<?php

require_once "Facade/KlienciPracownikFacade.php";

/**
 * Klasa odpowiedzialna za obsługę zdarzeń w podstronie Klienci dla Pracownika
 *
 * @author Mateusz Jurasz
 */
class KlienciPracownikController
{    
    function index()
    {
        $facade=new KlienciPracownikFacade();           
        $facade->pokaz();
    }
    
    function edytujWyswietl()
    {
        $facade=new KlienciPracownikFacade();           
        $facade->edytujWyswietl();
    }
    
    function edytujPotwierdz()
    {
        $facade=new KlienciPracownikFacade();           
        $facade->edytujPotwierdz();
    }
    
    function szukajWyswietl()
    {
        $facade=new KlienciPracownikFacade();           
        $facade->szukajWyswietl();
    }
    
    function szukajPotwierdz()
    {
        $facade=new KlienciPracownikFacade();           
        $facade->szukajPotwierdz();
    }
    
    function dodajWyswietl()
    {
        $facade=new KlienciPracownikFacade();           
        $facade->dodajWyswietl();
    }
    
    function dodajPotwierdz()
    {
        $facade=new KlienciPracownikFacade();           
        $facade->dodajPotwierdz();
    }
    
    //to do
    function pokazZlecenia()
    {
        $facade=new KlienciPracownikFacade();           
        $facade->dodajPotwierdz();
    }
    
    function wyloguj()
    {
        $facade=new LogowanieFacade();
        $facade->wyloguj();
    }
}
