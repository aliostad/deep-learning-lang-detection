from django.conf.urls import patterns, url

from nodesk_admin import views

urlpatterns = [
        url(
           r'^$',
           views.admin_console),
        url(
           r'^template_config_save/?$',
           views.template_config_save),
        url(
           r'^reload_server/?$',
           views.reload_server),
        url(
           r'^ldap_config_save/?$',
           views.ldap_config_save),
        url(
           r'^template_creator(/(?P<template_id>[0-9]+))?/?$',
           views.template_creator),
        url(
           r'^template_save/?$',
           views.template_save),]
