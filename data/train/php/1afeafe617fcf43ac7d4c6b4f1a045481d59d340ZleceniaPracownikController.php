<?php

require_once "Facade/ZleceniaPracownikFacade.php";

/**
 * Klasa odpowiedzialna za obsługę zdarzeń w podstronie Zlecenia dla Pracownika
 *
 * @author Mateusz Jurasz
 */
class ZleceniaPracownikController
{
    function index()
    {
        $facade=new ZleceniaPracownikFacade();           
        $facade->pokaz();
    }
    
    function edytujWyswietl()
    {
        $facade=new ZleceniaPracownikFacade();           
        $facade->edytujWyswietl();
    }
    
    function edytujPotwierdz()
    {
        $facade=new ZleceniaPracownikFacade();           
        $facade->edytujPotwierdz();
    }
    
    function szukajWyswietl()
    {
        $facade=new ZleceniaPracownikFacade();           
        $facade->szukajWyswietl();
    }
    
    function szukajPotwierdz()
    {
        $facade=new ZleceniaPracownikFacade();           
        $facade->szukajPotwierdz();
    }
    
    function dodajWyswietl()
    {
        $facade=new ZleceniaPracownikFacade();           
        $facade->dodajWyswietl();
    }
    
    function dodajPotwierdz()
    {
        $facade=new ZleceniaPracownikFacade();           
        $facade->dodajPotwierdz();
    }
    
    function pokazKlienta()
    {
        $facade=new KlientPracownikFacade();           
        $facade->szukajPotwierdz();
    }
    
    function wyloguj()
    {
        $facade=new LogowanieFacade();
        $facade->wyloguj();
    }
}
