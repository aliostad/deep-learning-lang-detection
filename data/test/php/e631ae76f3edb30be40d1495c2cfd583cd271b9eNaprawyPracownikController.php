<?php

require_once "Facade/NaprawyPracownikFacade.php";

/**
 * Klasa odpowiedzialna za obsługę zdarzeń w podstronie Naprawy dla Pracownika
 *
 * @author Mateusz Jurasz
 */
class NaprawyPracownikController
{
    function index()
    {
        $facade=new NaprawyPracownikFacade();           
        $facade->pokaz();
    }
    
    function edytujWyswietl()
    {
        $facade=new NaprawyPracownikFacade();           
        $facade->edytujWyswietl();
    }
    
    function edytujPotwierdz()
    {
        $facade=new NaprawyPracownikFacade();           
        $facade->edytujPotwierdz();
    }
    
    function szukajWyswietl()
    {
        $facade=new NaprawyPracownikFacade();           
        $facade->szukajWyswietl();
    }
    
    function szukajPotwierdz()
    {
        $facade=new NaprawyPracownikFacade();           
        $facade->szukajPotwierdz();
    }
    
    function dodajWyswietl()
    {
        $facade=new NaprawyPracownikFacade();           
        $facade->dodajWyswietl();
    }
    
    function dodajPotwierdz()
    {
        $facade=new NaprawyPracownikFacade();           
        $facade->dodajPotwierdz();
    }
    
    function pokazZlecenie()
    {
        $facade=new ZleceniaPracownikFacade();           
        $facade->szukajPotwierdz();
    }
    
    function wyloguj()
    {
        $facade=new LogowanieFacade();
        $facade->wyloguj();
    }
}
