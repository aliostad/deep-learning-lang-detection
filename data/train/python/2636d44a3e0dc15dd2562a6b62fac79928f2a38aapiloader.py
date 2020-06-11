#coding=utf-8
import confmanage,rstformater,GLOBAL

class ApiLoader():

	"""docstring for ApiLoader"""
	def __init__(self, apiPath):
		self.__apiPath = apiPath
		self.__apilist = self.preload_apilst()

	def execapi(self, api_url, api_params):
		'''
			execute the execution function in api handler then return a api result
		'''
		api_conf = self.search_api_conf(api_url)
		print 'api_conf => ', api_conf
		api_handler = api_conf.get('handler')
		api_rst = self.invok_api_execfunc(api_handler)
		return rstformater.jsonRst(api_rst)

	def preload_apilst(self):
		"""API列表预加载，解析api_conf.json配置文件并将api列表加载到内存"""
		GLOBAL.LOGGER.logInfo("Preloading api list...")
		api_lst =  confmanage.load_xml_api_confs(self.__apiPath)
		if api_lst.get('error') == 0 :
			if 'data' in api_lst :
				#结果集完好，读取api_list
				api_lst = api_lst.get('data')
			else :
				GLOBAL.LOGGER.logError("Configuations result format error")
				api_lst = None
		else :
			GLOBAL.LOGGER.logError("Unable to load api configuations ErrorCode:%s ErrorMessage:'%s'" % (api_lst['error'], api_lst['msg']))
			api_lst = None
		return api_lst
		
	def search_api_conf(self, url='', name=''):
		'''Search api conf in api list'''
		if self.__apilist == None :
			self.__apilist = self.preload_apilst()
		
		rst_val = None
		if len(url) > 0:
			for api in self.__apilist :
				for apiurl in api.get('resources').get('urls'):
					if apiurl == url:
						rst_val = rstformater.jsonRst(api)
						break
				if rst_val != None:
					break
		elif len(name) > 0:
			for api in self.__apilist:
				if api.get('name') == name:
					rst_val = rstformater.jsonRst(api)
					break
		else:
			rst_val = rstformater.jsonError(301, 'Api not found!')

		return rst_val

	def get_api_handler(self, handler_path):
		'''get api handler instance'''
		print handler_path
		
	def invok_api_execfunc(self, handler):
		'''invok the api execution function'''
		pass
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		