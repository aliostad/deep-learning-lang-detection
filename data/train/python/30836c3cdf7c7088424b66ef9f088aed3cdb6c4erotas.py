#! /usr/bin/python
# -*- coding: utf-8 -*-

from superconfronto.controller.login import LoginController
from superconfronto.controller.home import HomeController
from superconfronto.controller.logout import LogoutController
from superconfronto.controller.time import TimeController

rotas = (
    ['/', LoginController(), 'login', 'login_login'],
    ['/autenticacao', LoginController(), 'autenticacao', 'login_autenticacao'],
    
    ['/home', HomeController(), 'home', 'home_home'],

    ['/logout', LogoutController(), 'logout', 'logout_logout'],

    ['/time/cadastro', TimeController(), 'cadastro', 'time_cadastro'],
)
