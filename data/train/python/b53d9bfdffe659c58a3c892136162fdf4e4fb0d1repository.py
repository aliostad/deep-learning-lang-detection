#!/usr/bin/env python
"""
functionality for the setup of repositories;
this should really be more interface consuming
"""

import os
import pkg_resources
import subprocess

from paste.script.templates import var

class RepositorySetupError(Exception):
    """marker exception for errors occuring during repository setup"""

class RepositorySetup(object):
    """interface defining repository setup via TracLegos"""

    options = [] # variables needed for this repository

    def __init__(self):
        self.name = self.__class__.__name__
        if not hasattr(self, 'description'):
            self.description = self.__doc__ 

    def options_fulfilled(self, vars):
        """returns whether all of the options are provided in vars"""
        return set([option.name for option in self.options]).issubset(vars)

    def enabled(self):
        """
        is this type of repository capable of being created 
        on this computer?
        """
        return False

    def config(self):
        """return a dictionary of .ini options"""
        return {}
    
    def setup(self, **vars):
        """
        create the repository
        """

class NoRepository(RepositorySetup):
    """No repository"""
    options = []
    
    def enabled(self):
        return True

    def __len__(self):
        """test False"""
        return 0


class NewSVN(RepositorySetup):
    """Create a new SVN repository"""
    options = [ var('repository_dir', 'location to create the SVN repository')]

    def enabled(self):
        try:
            subprocess.call(['svnadmin', 'help'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            return True
        except OSError:
            return False

    def config(self):
        return { 'trac': { 'repository_dir': '${repository_dir}',
                           'repository_type': 'svn' } }

    def setup(self, **vars):
        if not self.options_fulfilled(vars):
            raise RepositorySetupError("Missing directory")
        subprocess.call(['svnadmin', 'create', vars['repository_dir']])
        
class ExistingSVN(RepositorySetup):
    """Use an existing repository"""
    options = [ var('repository_dir', 'location of SVN repository') ]

    def enabled(self):
        return True

    def config(self):
        return { 'trac': { 'repository_dir': '${repository_dir}',
                           'repository_type': 'svn' } }
                        
class SVNSync(RepositorySetup):
    """Mirror SVN (1.4) repository"""
    options = [ var('repository_url', 'URL of remote svn repository (must be SVN v1.4)',
                    default='http://'),
                var('repository_dir', 'desired mirror location') ]

    def enabled(self):
        try:
            import svnsyncplugin
        except ImportError:
            return False
        return True

    def config(self):
        return { 'svn': { 'repository_url': '${repository_url}', },
                 'trac': { 'repository_dir': '${repository_dir}',
                           'repository_type': 'svnsync' } } 

    def setup(self, **vars):
        if not self.options_fulfilled(vars):
            raise RepositorySetupError("Missing options")
        raise NotImplementedError # TODO


class NewMercurialRepository(RepositorySetup):
    """Create a new Mercurial repository"""

    options = [ var('hg_repository_dir', 'location to create Hg repository') ]

    def enabled(self):
        try:
            import tracext.hg
        except ImportError:
            return False
        try:
            import subprocess
            retval = subprocess.call(["hg"], stdout=subprocess.PIPE)
            return not retval
        except:
            return False

    def config(self):
        return { 'components': { 'tracext.hg': 'enabled' },
                 'trac': { 'repository_dir': '${hg_repository_dir}',
                           'repository_type': 'hg' } } 
            

def available_repositories():
    """return installed and enabled repository setup methods"""
    repositories = []
    for entry_point in pkg_resources.iter_entry_points('traclegos.respository'):
        try:
            repository = entry_point.load()
        except:
            continue
        repository = repository()
        if repository.enabled():
            repositories.append(repository)
    return dict((repository.name, repository) for repository in repositories)


if __name__ == '__main__':
    print 'Available repositories:'
    for name, repository in available_repositories().items():
        print '%s: %s' % (name, repository.description)
