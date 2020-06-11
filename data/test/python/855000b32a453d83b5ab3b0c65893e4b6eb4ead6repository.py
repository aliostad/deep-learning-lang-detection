import os.path
import re

from sqlalchemy import select, func
from sqlalchemy import Column, PrimaryKeyConstraint, ForeignKey, UniqueConstraint
from sqlalchemy import Boolean, Integer, BigInteger, Text
from sqlalchemy import Enum
from sqlalchemy.orm import relationship, column_property, reconstructor

import knotcake.concurrency

from irepository import IRepository

class Repository(IRepository):
	__abstract__                = True
	
	# Settings
	repositoryDirectoryName     = None
	repositoryDirectoryLockName = "lock"
	
	repositoryDirectoryPath     = None
	repositoryDirectoryLock     = None
	
	def __init__(self):
		super(Repository, self).__init__()
		
		self.init()
	
	@reconstructor
	def init(self):
		self._repositoryLock = None
	
	# IRepository
	def gc(self, databaseSession):
		self.getRepositoryDirectoryLock().lock()
		if databaseSession.query(self.repositoryTreeClass).with_parent(self).count() == 0:
			self.uninitialize()
			databaseSession.delete(self)
			databaseSession.commit()
		self.getRepositoryDirectoryLock().unlock()
	
	def getFullPath(self):
		return os.path.join(self.getRepositoryDirectoryPath(), self.directoryName)
	
	@property
	def redactedUrl(self):
		return re.sub(r"/[^/:@]*(:[^/:@]*)?@", u"/", self.url)
	
	# Static
	@classmethod
	def create(cls, databaseSession, url):
		cls.getRepositoryDirectoryLock().lock()
		
		# Acquire
		repository = cls.getByUrl(databaseSession, url)
		if repository: return repository
		
		# Create
		repository = cls()
		repository.url = url
		repository.directoryName = cls.generateDirectoryName(databaseSession, repository)
		
		# Clone
		repository.initialize()
		
		# Commit to database
		databaseSession.add(repository)
		databaseSession.commit()
		cls.getRepositoryDirectoryLock().unlock()
		
		return repository
	
	@classmethod
	def setRepository(cls, databaseSession, repositoryUrl, repositoryTree):
		databaseSession.commit()
		
		cls.getRepositoryDirectoryLock().lock()
		repository = repositoryTree.repository
		
		# Set new repository
		if repositoryUrl is None:
			repositoryTree.repository = None
			databaseSession.delete(repositoryTree)
		else:
			repositoryTree.repository = cls.create(databaseSession, repositoryUrl)
			databaseSession.add(repositoryTree)
		
		databaseSession.commit()
		
		# Clean up old repository
		if repository is not None:
			repository.gc(databaseSession)
		
		cls.getRepositoryDirectoryLock().unlock()
	
	@classmethod
	def getByUrl(cls, databaseSession, url):
		repository = databaseSession.query(cls).filter(cls.url == url).first()
		return repository
	
	@classmethod
	def getByDirectoryName(cls, databaseSession, directoryName):
		repository = databaseSession.query(cls).filter(cls.directoryName == directoryName).first()
		return repository
	
	# Repository
	# Internal
	@property
	def repositoryTreeClass(self):
		raise NotImplementedError()
	
	def initialize(self):
		raise NotImplementedError()
	
	def uninitialize(self):
		raise NotImplementedError()
	
	def directoryExists(self):
		return os.path.exists(self.getFullPath())
	
	@property
	def repositoryLock(self):
		if self._repositoryLock is None:
			lockPath = self.getFullPath() + ".lock"
			self._repositoryLock = knotcake.concurrency.FileLock(lockPath)
		
		return self._repositoryLock
	
	# Static
	# Internal
	@classmethod
	def getRepositoryDirectoryPath(cls):
		if cls.repositoryDirectoryPath is None:
			cls.repositoryDirectoryPath = os.path.join(__file__, "../../data")
			cls.repositoryDirectoryPath = os.path.join(cls.repositoryDirectoryPath, cls.repositoryDirectoryName)
			cls.repositoryDirectoryPath = os.path.normpath(cls.repositoryDirectoryPath)
			if not os.path.exists(cls.repositoryDirectoryPath):
				os.makedirs(cls.repositoryDirectoryPath)
			print(cls.repositoryDirectoryPath)
		
		return cls.repositoryDirectoryPath
	
	@classmethod
	def generateDirectoryName(cls, databaseSession, repository):
		from pathutils import PathUtils
		
		assert(cls.getRepositoryDirectoryLock().acquired)
		
		baseDirectoryName = repository.redactedUrl
		baseDirectoryName = PathUtils.createFileName(baseDirectoryName)
		baseDirectoryName = baseDirectoryName.lower()
		if cls.isDirectoryNameFree(databaseSession, baseDirectoryName):
			return baseDirectoryName
		
		n = 2
		while not cls.isDirectoryNameFree(databaseSession, baseDirectoryName + u"_" + unicode(n)):
			n += 1
		
		return baseDirectoryName + u"_" + unicode(n)
	
	@classmethod
	def isDirectoryNameFree(cls, databaseSession, directoryName):
		if directoryName == "": return False
		if directoryName == cls.repositoryDirectoryLockName: return False
		if directoryName == cls.repositoryDirectoryLockName + ".lock": return False
		
		if cls.getByDirectoryName(databaseSession, directoryName) is not None: return False
		if cls.getByDirectoryName(databaseSession, directoryName + ".lock") is not None: return False
		if directoryName.endswith(".lock"):
			if cls.getByDirectoryName(databaseSession, directoryName[:-len(".lock")]) is not None: return False
		
		return True
	
	# Lock for acquiring and releasing references to Repositories
	# Lock for garbage collecting Repositories too
	@classmethod
	def getRepositoryDirectoryLock(cls):
		if cls.repositoryDirectoryLock is None:
			lockPath = os.path.join(cls.getRepositoryDirectoryPath(), cls.repositoryDirectoryLockName + ".lock")
			print(lockPath)
			cls.repositoryDirectoryLock = knotcake.concurrency.FileLock(lockPath)
		
		return cls.repositoryDirectoryLock
