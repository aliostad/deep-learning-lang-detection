# This Python file uses the following encoding: utf-8
from aula.apps.incidencies.abstract_models import AbstractFrassesIncidenciaAula,\
    AbstractSancio, AbstractExpulsio, AbstractIncidencia, AbstractTipusIncidencia, AbstractTipusSancio
from aula.apps.incidencies.business_rules.sancio import sancio_pre_delete,\
    sancio_post_save, sancio_pre_save,\
    sancio_clean
from aula.apps.incidencies.business_rules.incidencia import Incidencia_post_save,\
    incidencia_pre_save, Incidencia_pre_delete, incidencia_clean
from aula.apps.incidencies.business_rules.expulsio import expulsio_pre_delete,\
    expulsio_post_save, expulsio_pre_save, expulsio_clean

class FrassesIncidenciaAula(AbstractFrassesIncidenciaAula):
    pass

class TipusSancio(AbstractTipusSancio):
    def clean(self):
        pass

class Sancio(AbstractSancio):
    def clean(self):
        sancio_clean(self)

class Expulsio(AbstractExpulsio):
    def clean(self):
        expulsio_clean(self)

class TipusIncidencia(AbstractTipusIncidencia):
    def clean(self):
        pass

class Incidencia(AbstractIncidencia):
    def clean(self):
        incidencia_clean(self)
        
# ----------------------------- B U S I N E S S       R U L E S ------------------------------------ #
from django.db.models.signals import post_save, pre_save, pre_delete

#incidencia
pre_delete.connect(Incidencia_pre_delete, sender= Incidencia)
pre_save.connect(incidencia_pre_save, sender = Incidencia )
post_save.connect(Incidencia_post_save, sender = Incidencia )

#expulsio del centre
pre_save.connect(sancio_pre_save, sender = Sancio )
post_save.connect(sancio_post_save, sender = Sancio )
pre_delete.connect(sancio_pre_delete, sender = Sancio )
       
#expulsio
pre_delete.connect(expulsio_pre_delete, sender= Expulsio)
pre_save.connect(expulsio_pre_save, sender = Expulsio )
post_save.connect(expulsio_post_save, sender = Expulsio )
pre_delete.connect(expulsio_pre_delete, sender = Expulsio )




