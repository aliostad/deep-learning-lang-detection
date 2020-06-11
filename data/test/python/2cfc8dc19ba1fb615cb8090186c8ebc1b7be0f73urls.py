# -*- encoding: utf-8 -*-

from django.conf.urls import url
from django.conf.urls.defaults import patterns

urlpatterns = patterns('collaborador.views',
    url(r'^stat/$', 'estat', name='manage_estat'),

    #Nou Talonari:    
    url(r'^addqr/clinex$', 'addQRClinex', name='manage_clinex_addqr'),
    
    #Nou QR Mosqueter:
    url(r'^addqr/mosqueter$', 'addQRMosqueter', name='manage_mosqueter_addqr'),

    #Nou Premi:
    url(r'^premis/addPremi$', 'addPremi', name='manage_premis_addpremi'),            

    #Edit Premi:
    url(r'^premis/editPremi/(?P<pk>\d*)$', 'editPremi', name='manage_premis_editpremi'),            

    #Imprimir un talonari o un QR
    url(r'^listtalonari/(?P<talonari_pk>\d*)$', 'listTalonari', name='manage_clinex_listqrs'),    
    url(r'^listmosqueter/(?P<mosqueter_pk>\d*)$', 'listMosqueter', name='manage_mosqueter_listqr'),    

    #Llistat tots els talonaris
    url(r'^listtalonaris$', 'listTalonaris', name='manage_clinex_listtalonaris'),    

    #Llistat tots els mosqueters
    url(r'^listmosqueters$', 'listMosqueters', name='manage_mosqueter_list'),

    #llistat recollides pendents
    url(r'^recollidesPendents/$', 'recollidesDePremisList', name='manage_recollidesdepremi_list'),
 
    #Llistat tots els premis    
    url(r'^listpremis$', 'listPremis', name='manage_premis_listpremis'),    

    #Llistat facturació    
    url(r'^facturacio$', 'listFacturacio', name='manage_facturacio_list'),    


)