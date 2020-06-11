#Includes BaseClassApi class
import BaseClassApi

class Augmentor(BaseClassApi.Api):
	pass
        #print "This is augmentor api class: \n"

def execute_augmentor_api():

        BaseClassApi.Api.url_path = "api/v1/augmentors"
        aug_api = Augmentor()
        #This module gives list of organizations available.
        aug_api.list_operation()
        #This module uploads file i.e. json data and returns upload id.
        #BaseClassApi.Api.upload_id = aug_api.upload_file_operation(json_file_name)
        #This is the payload information which is required for creating organization.
     ##   #BaseClassApi.Api.payload = {"organization": {"name": "New organization1", "url": "www.test1.com", "upload_id": "%s" %BaseClassApi.Api.upload_id }}
        BaseClassApi.Api.payload = {"augmentor": {"name" : "audience name" , "upload_id":"%s" %BaseClassApi.Api.upload_id}}
        #This module creates organization.
        BaseClassApi.Api.aug_id = aug_api.create_operation()
        #BaseClassApi.Api.general_id = ""
        #This is the payload information which is required for updating organization.
    ##  BaseClassApi.Api.payload = {"organization": {"name": "Rename organization1", "url": "www.test1.com", "upload_id": "%s" %BaseClassApi.Api.upload_id }}
        BaseClassApi.Api.payload = {"augmentor": {"name" : "audience name" , "upload_id":"%s" %BaseClassApi.Api.upload_id}}
        #This module updates organization.
        aug_api.update_operation(BaseClassApi.Api.aug_id)
        #This module gives details of specific organization
        aug_api.show_operation(BaseClassApi.Api.aug_id)
        #This module deletes organization
        ########################
	#aug_api.destroy_operation(BaseClassApi.Api.aug_id)

