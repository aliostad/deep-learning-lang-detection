#Includes BaseClassApi class
import BaseClassApi

class Adsize(BaseClassApi.Api):
	pass
        #print "This is Adsize api class: \n"

def execute_adsize_api():

        BaseClassApi.Api.url_path = "api/v1/adsizes"
        adsize_api = Adsize()
        #This module gives list of organizations available.
        adsize_api.list_operation()
        #This module uploads file i.e. json data and returns upload id.
        #BaseClassApi.Api.upload_id = aug_api.upload_file_operation(json_file_name)
        #This is the payload information which is required for creating organization.
     ##   #BaseClassApi.Api.payload = {"organization": {"name": "New organization1", "url": "www.test1.com", "upload_id": "%s" %BaseClassApi.Api.upload_id }}
        BaseClassApi.Api.payload = {"adsize" : {"width" : 120, "height": 20 , "format" : "png", "status" : "active"}}
        #This module creates organization.
        BaseClassApi.Api.adsize_id = adsize_api.create_operation()
        #BaseClassApi.Api.general_id = ""
        #This is the payload information which is required for updating organization.
    ##  BaseClassApi.Api.payload = {"organization": {"name": "Rename organization1", "url": "www.test1.com", "upload_id": "%s" %BaseClassApi.Api.upload_id }}
        BaseClassApi.Api.payload = {"adsize" : {"width" : 140, "height": 20 , "format" : "png", "status" : "active"}}
        #This module updates organization.
        adsize_api.update_operation(BaseClassApi.Api.adsize_id)
        #This module gives details of specific organization
        adsize_api.show_operation(BaseClassApi.Api.adsize_id)
        #This module deletes organization
        ########################adsize_api.destroy_operation(BaseClassApi.Api.adsize_id)

