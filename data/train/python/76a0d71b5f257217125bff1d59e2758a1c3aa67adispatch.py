#=======================================================================

__version__ = '''0.0.01'''
__sub_version__ = '''20050819183526'''
__copyright__ = '''(c) Alex A. Naanou 2003'''


#-----------------------------------------------------------------------



#-----------------------------------------------------------------------
#-------------------------------------------------------DispatchError---
class DispatchError(Exception):
	pass



#-----------------------------------------------------------------------
#----------------------------------------------------AbstractDispatch---
class AbstractDispatch(object):
	'''
	'''
	pass


#-------------------------------------------------------BasicDispatch---
# Q: this is basicly a dict, so do we need a special interface????
class BasicDispatch(AbstractDispatch):
	'''
	'''
	__targets__ = None

	# basic methods...
	def resolve(self, marker):
		'''
		'''
		try:
			return self.__targets__[marker]
		except KeyError:
			raise DispatchError, 'marker "%s" is not present in the targets list.' % marker
	# rule manipulation...
	def addrule(self, marker, target):
		'''
		'''
		if hasattr(self, '__targets__') and self.__targets__ != None:
			self.__targets__[marker] = target
		else:
			self.__targets__ = {marker: target}
	def delrule(self, marker):
		'''
		'''
		if hasattr(self, '__targets__') and self.__targets__ != None and marker in self.__targets__:
			del self.__targets__[marker]
		else:
			raise DispatchError, 'no rule defined for marker %s.' % marker
	def clearrules(self):
		'''
		'''
		del self.__targets__
	def getrules(self):
		'''
		'''
		return self.__targets__


#-------------------------------------------------------BasicDispatch---
class CallableDispatch(BasicDispatch):
	'''
	'''
	def __call__(self, *p, **n):
		'''
		'''
		return self.resolve(*p, **n)
	


#=======================================================================
#                                            vim:set ts=4 sw=4 nowrap :
