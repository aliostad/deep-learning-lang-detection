class NoRouteError(Exception):
	def __init__(self, insight = ""):
		self.str = "The route specified does not exsist.\n"
		self.insight = repr(insight)
	def __str__(self):
		return self.str + self.insight
class Dispatcher:
	def __init__(self, dispatchDict={}):
		self._dispatchDict = dispatchDict
	def addRoute(self, keyword, worker):
		self._dispatchDict[keyword] = worker
	def dispatch(self, keyword):
		try:
			worker = self._dispatchDict[keyword]
		except keyError:
			raise NoRouteError(self._dispatchDict)
		else:
			worker()