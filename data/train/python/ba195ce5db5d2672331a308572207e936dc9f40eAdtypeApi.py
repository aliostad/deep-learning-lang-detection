#Includes BaseClassApi class
import BaseClassApi

class Adtype(BaseClassApi.Api):
	pass
	#print "This is Adtype api class: \n"

def execute_adtype_api():

        BaseClassApi.Api.url_path = "api/v1/adtypes"
        adtype_api = Adtype()
        #This module gives list of organizations available.
        adtype_api.list_operation()
        #This module uploads file i.e. json data and returns upload id.
        #BaseClassApi.Api.upload_id = aug_api.upload_file_operation(json_file_name)
        #This is the payload information which is required for creating organization.
     ##   #BaseClassApi.Api.payload = {"organization": {"name": "New organization1", "url": "www.test1.com", "upload_id": "%s" %BaseClassApi.Api.upload_id }}
        BaseClassApi.Api.payload = {"adtype" : {"name" : "Simple", "status" : "active"}}
        #This module creates organization.
        BaseClassApi.Api.adtype_id = adtype_api.create_operation()
        #BaseClassApi.Api.general_id = ""
        #This is the payload information which is required for updating organization.
    ##  BaseClassApi.Api.payload = {"organization": {"name": "Rename organization1", "url": "www.test1.com", "upload_id": "%s" %BaseClassApi.Api.upload_id }}
        BaseClassApi.Api.payload = {"adtype" : {"name" : "Simpleupdate", "status" : "active"}}
        #This module updates organization.
        adtype_api.update_operation(BaseClassApi.Api.adtype_id)
        #This module gives details of specific organization
        adtype_api.show_operation(BaseClassApi.Api.adtype_id)
        #This module deletes organization
        ########################aug_api.destroy_operation(BaseClassApi.Api.adtype_id)

