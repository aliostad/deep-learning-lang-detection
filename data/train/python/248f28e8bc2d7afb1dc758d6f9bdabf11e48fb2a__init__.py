__author__ = "Zygimantas Gatelis"
__email__ = "zygimantas.gatelis@cern.ch"


from relval import app
from relval.rest.resources_api import \
    UsersListApi, PredefinedBlobsApi, PredefinedBlobApi,\
    StepsApi, StepApi, RequestsApi, \
    RequestApi, BatchesApi, BatchApi
from relval.rest.validation_api import \
    StepsValidationApi, RequestsValidationApi, BlobsValidationApi, BatchesValidationApi
from relval.rest.details_api import BlobDetailsApi, StepDetailsApi, RequestDetailsApi, BatchDetailsApi
from relval.rest.users_api import UsersResource
from relval.rest.commands_api import RequestCommandApi, RequestLogsCommandApi, RunTheMatrixConfigurationApi
from flask.ext.restful import Api


restful_api = Api(app)
restful_api.add_resource(UsersListApi, "/api/users")
restful_api.add_resource(PredefinedBlobsApi, "/api/predefined_blob")
restful_api.add_resource(PredefinedBlobApi, "/api/predefined_blob/<int:blob_id>")
restful_api.add_resource(StepsApi, "/api/steps")
restful_api.add_resource(StepApi, "/api/steps/<int:step_id>")
restful_api.add_resource(RequestsApi, "/api/requests")
restful_api.add_resource(RequestApi, "/api/requests/<int:request_id>")
restful_api.add_resource(BatchesApi, "/api/batches")
restful_api.add_resource(BatchApi, "/api/batches/<int:batch_id>")

# validation
restful_api.add_resource(StepsValidationApi, "/api/validate/step/<field>")
restful_api.add_resource(RequestsValidationApi, "/api/validate/request/<field>")
restful_api.add_resource(BlobsValidationApi, "/api/validate/blob/<field>")
restful_api.add_resource(BatchesValidationApi, "/api/validate/batch/<field>")

# details
restful_api.add_resource(BlobDetailsApi, "/api/predefined_blob/<int:item_id>/details")
restful_api.add_resource(StepDetailsApi, "/api/steps/<int:item_id>/details")
restful_api.add_resource(RequestDetailsApi, "/api/requests/<int:item_id>/details")
restful_api.add_resource(BatchDetailsApi, "/api/batches/<int:item_id>/details")

# users resources
restful_api.add_resource(UsersResource, "/api/users/<field>")

# commands api
restful_api.add_resource(RequestCommandApi, "/api/commands/test/<int:request_id>")
restful_api.add_resource(RequestLogsCommandApi, "/api/commands/test/logs/<int:request_id>")

# endpoints for integration into
restful_api.add_resource(RunTheMatrixConfigurationApi, "/api/conf/tests/<int:request_id>")

