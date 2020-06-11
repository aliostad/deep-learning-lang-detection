# coding: utf-8
#!/usr/bin/env python

from torneira.core.dispatcher import url
from supercraques.controller.banca import BancaController
from supercraques.controller.home import HomeController
from supercraques.controller.facebook import FacebookController
from supercraques.controller.desafio import DesafioController

urls = (
        
    url("/", HomeController, action="login", name="login"),
    url("/login", HomeController, action="login", name="login"),
    url("/auth/login", HomeController, action="auth_login", name="auth_login"),
    url("/home", HomeController, action="home", name="home"),
   
    url("/equipes.{extension}", BancaController, action="busca_equipes", name="busca_equipes"),
    url("/equipe/{equipe_id}/atletas.{extension}", BancaController, action="busca_atletas_por_equipe", name="busca_atletas_por_equipe"),
    url("/equipe/{equipe_id}/posicao/{posicao}/atletas.{extension}", BancaController, action="busca_atletas_por_equipe_e_posicao", name="busca_atletas_por_equipe_e_posicao"),
    url("/posicao/{posicao}/atletas.{extension}", BancaController, action="busca_atletas_por_posicao", name="busca_atletas_por_posicao"),
    
    url("/banca", BancaController, action="banca", name="banca"),
    url("/supercraque.{extension}", BancaController, action="get_supercraque", name="get_supercraque"),
    url("/atletas_card.{extension}", BancaController, action="atletas_card", name="atletas_card"),
    url("/cards", BancaController, action="cards_box", name="cards_box"),
    url("/atleta/{atleta_id}/comprar", BancaController, action="comprar_card", name="comprar_card"),
    url("/atleta/{atleta_id}/descartar", BancaController, action="descartar_card", name="descartar_card"),
    
    url("/loadAtletas.json", DesafioController, action="load_atletas", name="load_atletas"),
    url("/desafio/card/{card_id}/usuario_desafiado/{usuario_desafiado_id}/desafiar", DesafioController, action="enviar_desafio", name="enviar_desafio"),
    url("/desafio/{desafio_id}/card/{card_id}/aceitar", DesafioController, action="aceitar_desafio", name="aceitar_desafio"),
    url("/desafio/enviados.{extension}", DesafioController, action="busca_desafios_enviados", name="busca_desafios_enviados"),
    url("/desafio/recebidos.{extension}", DesafioController, action="busca_desafios_recebidos", name="busca_desafios_recebidos"),
    url("/desafio/todos.{extension}", DesafioController, action="busca_desafios_todos", name="busca_desafios_todos"),
    url("/desafio/resultados", DesafioController, action="desafios_resultado", name="desafios_resultado"),

    url("/fb/friends.{extension}", FacebookController, action="friends", name="friends"),
)