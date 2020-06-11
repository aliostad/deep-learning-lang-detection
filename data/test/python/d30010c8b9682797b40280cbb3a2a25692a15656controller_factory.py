# -*- coding: utf-8 -*-
from api.controller.produto_controller import ProdutoController
from api.controller.safra_controller import SafraController
from api.controller.servico_controller import ServicoController
from api.models.produto import ProdutoSchema
from api.models.safra import SafraSchema
from api.models.servico import ServicoSchema


class ControllerFactory:
    
    def get(self, model):
        if model.lower() == "produto": return ProdutoController(), ProdutoSchema()
        if model.lower() == "safra": return SafraController(), SafraSchema()
        if model.lower() == "servico": return ServicoController(), ServicoSchema()
        raise Exception("Controller %s não implementado" % model)
        
