#!/usr/bin/python
# -*- coding: utf-8 -*-
# kate: space-indent on; indent-width 4; mixedindent off; indent-mode python;

from SubversionRepository import SubversionRepository
import sys, os
from arsoft.utils import enum
import arsoft.git

class RepositoryFactory:
    Type = enum(Invalid=-1, Unknown=0, Subversion=1, Git=2)

    @staticmethod
    def detect_type(path):
        if os.path.isdir(path):
            if SubversionRepository.is_valid(path):
                return RepositoryFactory.Type.Subversion
            elif arsoft.git.GitRepository.find_repository_root(path) is not None:
                return RepositoryFactory.Type.Git
            else:
                return RepositoryFactory.Type.Unknown
        else:
            return RepositoryFactory.Type.Invalid

    @staticmethod
    def create(path, verbose=False, traverse_parent_dirs=False):
        ret = None
        if os.path.isdir(path):
            if ret is None:
                if SubversionRepository.is_valid(path):
                    ret = SubversionRepository(path, verbose=verbose)
            if ret is None:
                if traverse_parent_dirs:
                    repo_path = arsoft.git.GitRepository.find_repository_root(path)
                    if repo_path is not None:
                        ret = arsoft.git.GitRepository(repo_path, verbose=verbose)
                else:
                    if arsoft.git.GitRepository.is_git_repository(path):
                        ret = arsoft.git.GitRepository(path, verbose=verbose)

        return ret
 
if __name__ == "__main__":
    print(sys.argv[1])
    repo = RepositoryFactory.create(sys.argv[1], verbose=True)
    print(repo)
    print(repo.path)
    print(repo.current_revision)
