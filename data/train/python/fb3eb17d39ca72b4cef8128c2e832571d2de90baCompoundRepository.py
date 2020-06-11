import os
from src.repository.AllInOneRepository import AllInOneRepository
from src.repository.FSRepository import FSRepository

__author__ = 'trentcioran'

class CompoundRepository:

    def __init__(self, root):
        self.root = root
        self.profilePerFolderRepository = FSRepository(root)
        self.sinlgeFolderRepository = AllInOneRepository(root)

    def writePhoto(self, profileName, filename, picture):
        self.profilePerFolderRepository.writePhoto(profileName, filename, picture)
        self.sinlgeFolderRepository.writePhoto(profileName, filename, picture)

    def writeProfile(self, profileName, profile):
        self.profilePerFolderRepository.writeProfile(profileName, profile)
        self.sinlgeFolderRepository.writeProfile(profileName, profile)

    def profile_exist(self, profileName):
        return self.profilePerFolderRepository.profile_exist(profileName)

    def read_profile(self, profileName):
        return self.profilePerFolderRepository.read_profile(profileName)
