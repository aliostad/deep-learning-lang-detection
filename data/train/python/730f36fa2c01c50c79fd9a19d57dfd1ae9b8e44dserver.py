# -*- coding: utf-8 -*-

from main import *
from config import *

from postgresapi import *
from elasticoapi import *
from pymongoapi import *
from neo4japi import *

# Curation EndPoints
api.add_resource(DistoPro, "/api/curation/distopro")
api.add_resource(DrutoDis, "/api/curation/drutodis")
api.add_resource(DrutoPro, "/api/curation/drutopro")

# Validation EndPoints
api.add_resource(DistoDis, "/api/validation/distodis")
api.add_resource(DrutoDru, "/api/validation/drutodru")
api.add_resource(ProtoPro, "/api/validation/protopro")

# Postgres View/Edit Table Api
api.add_resource(DetailTable, "/api/curation/detailtable")

# Elastic Search Api
api.add_resource(SearchAll, "/api/search/all")




