

##################################################

class RepositoryInternal:
	def __init__(self):
		self.uuid_counter = 0
		self.mappings = {}

class LocalRepository:
	def __init__(self, data = None):
		if data == None:
			data = RepositoryInternal()
		self.data = data

	def uuid(self):
		try:
			return 'u%05d' % self.data.uuid_counter
		finally:
			self.data.uuid_counter += 1

	def lookup(self, uuid):
		assert type(uuid) == str
		return self.data.mappings[uuid]
	
	def register(self, uuid, v):
		assert type(uuid) == str
		self.data.mappings[uuid] = v

class SharedRepository:
	def __init__(self):
		import threading
		self.lock = threading.Lock()
		self.data = RepositoryInternal()
	
	def uuid(self):
		self.lock.acquire()
		try:
			return 'u%05d' % self.data.uuid_counter
		finally:
			self.data.uuid_counter += 1
			self.lock.release()

	def lookup(self, uuid):
		assert type(uuid) == str
		self.lock.acquire()
		try:
			return self.data.mappings[uuid]
		finally:
			self.lock.release()
	
	def register(self, uuid, v):
		assert type(uuid) == str
		self.lock.acquire()
		try:
			self.data.mappings[uuid] = v
		finally:
			self.lock.release()

Repository = SharedRepository

##################################################

global_repository = Repository()
uuid, lookup, register = global_repository.uuid, global_repository.lookup, global_repository.register

def get_global_repository():
	global global_repository
	return global_repository

def set_global_repository(repository):
	global global_repository
	global uuid, lookup, register 
	old_global_repository = global_repository
	global_repository = repository
	uuid, lookup, register = repository.uuid, repository.lookup, repository.register
	return old_global_repository

##################################################

def register_object(obj):
	id = uuid()
	register(id, obj)
	return id

class Mixin:
	def __init__(self):
		self.register_self()

	def register_self(self):
		"This method can be called by cloned objects to register themselves as new objects."
		self.uuid = uuid()
		register(self.uuid, self)

	def register_self_in(self, repository):
		"This method can be called by cloned objects to register themselves in a new repository."
		self.uuid = repository.uuid()
		repository.register(self.uuid, self)

##################################################

def trace(data = None):
	'Only for debug usage'
	data = data or global_repository.data
	m = data.mappings
	for k, v in sorted(m.items()):
		print '%6s => %s' % (k, v)

def trace_classes(data = None):
	'Only for debug usage'
	data = data or global_repository.data
	m = data.mappings
	classes = {}
	no_classes = []
	for k, v in m.items():
		if hasattr(v, '__class__'):
			c = v.__class__
			if classes.has_key(c):
				classes[c] += 1
			else:
				classes[c] = 1
		else:
			no_classes.append((k, v))
	print 'Non-object:'
	for k, v in no_classes:
		print '\t%s' % v
	print 'Objects:'
	for k, v in classes.items():
		print '\t%-20s\t%s' % (k, v)

##################################################

if __name__ == '__main__':
	print uuid()
	print uuid()
	register('x', 'hehe')
	print lookup('x')
	Mixin()
	trace()

