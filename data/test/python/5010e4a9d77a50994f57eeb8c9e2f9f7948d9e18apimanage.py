#coding=utf-8
import confmanage,os,imp,GLOBAL,json


class ApiManagerFactory:
	API_MANAGER = None
	def getInstance(self, apiPath=''):
		if self.API_MANAGER == None:
			API_MANAGER = ApiManager(apiPath)
		return API_MANAGER


class ApiManager():

	def __init__(self, apiPath):
		"""docstring for ApiManager"""
		self.__apiPath = apiPath
		self.__apiList = self.loadApilst()

	def execApi(self, url, params, datas, method="get", res="json"):
		"""execute the execution function in api handler then return a api result
			执行API出黎类的execute方法取得Api执行结果
		"""
		# print '__apiList => ', self.__apiList
		api = self.searchApi(url=url)
		rst = -1
		# print 'api => ', api
		if api and api > 0:
			rst = api.execute(params=params, datas=datas, method=method, res=res)
		else:
			rst = api
			
		return rst

	def loadApilst(self):
		"""
		API列表预加载，解析api_conf.json配置文件并将api列表加载到内存
		return api confs list when success otherwise a small then 0 int error code instead
		-- error code 
		---- -1:Unable to load api configuations
		---- -2:Configuations result format error
		"""
		#获取Api配置
		api_confs =  json.loads(confmanage.load_xml_api_confs(self.__apiPath))
		# print 'api_confs => ', api_confs
		if api_confs.get('errnum') == 0 :
			if 'data' in api_confs :
				#结果集完好，读取api_list
				rst_val = api_confs.get('data')
				api_list = {}
				
				for api in rst_val:
					#过滤从配置文件中获取的api配置列表，如果在配置文件中load=False的话，不会对Api进行加载
					if api.get('load', True) == 'True' or api.get('load', True) == True:
						api.get('resources', {}).get('url', '')
						api_list.update({api.get('resources', {}).get('url', ''):self.getHandler(api)})

				rst_val = api_list
			else :
				rst_val = -2
		else :
			rst_val = -1
		return rst_val

	def searchApi(self,url='', name=''):
		"""Search api handler in api list
			在api list中搜索Api处理类
		"""
		apiLst = self.getApiLst()
		
		rst_val = None
		if len(url) > 0:
			api = self.__apiList.get(url.strip().lower(), None)
			if api:
				rst_val = api
		elif len(name) > 0:
			for api in apiLst:
				if api.getName == name:
					rst_val = api
					break
		if rst_val == None:
			rst_val = -1

		return rst_val

	def getHandler(self, conf):
		'''get api handler instance
			获取API处理类对象
		'''
		handler = conf.get('handler', {})  #从配置获取handler配置
		#获取模块对象
		handlerModule = imp.load_source(handler.get('moduleName', ''), "%s%s%s.py" % (self.__apiPath, os.sep, handler.get('modulePath', '')))
		#获取处理类
		HandlerClass = getattr(handlerModule, handler.get('className', ''))
		#返回处理类实例
		return HandlerClass(
						name = conf.get('name', ''),
						enable = conf.get('enable', True), 
						level = conf.get('level', 0), 
						resType = conf.get('resources', {}).get('resType', ''),
						url = conf.get('resources', {}).get('url', ''),
						remote = handler.get('remote', False))
	

	def getApiLst(self):
		if self.__apiList == None:
			self.__apiList = self.loadApilst()
		return self.__apiList
