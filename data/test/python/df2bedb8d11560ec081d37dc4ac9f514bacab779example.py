#Name: Bhavesh Sharma

from browserstack import auth,api
import config

auth = auth.AuthHandler(config.USERNAME,config.ACCESS_KEY,proxy_data=None)

apiO = api.API(auth, api_root='/2')

#apiO._create_browser_worker(os_version="Mountain Lion", browser_version="12.12", os="OS X",browser="opera")
#print apiO.result

#apiO._get_browsers(all="true",flat="true")
#print apiO.result

#apiO._api_status()
#print apiO.result

apiO._get_workers()
print apiO.result

#apiO._get_worker_byId(id= "20328877")
#print apiO.result

#apiO._delete_worker(id= "20220444")
#print apiO.result





