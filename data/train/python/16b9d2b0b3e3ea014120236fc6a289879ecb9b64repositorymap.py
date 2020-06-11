#
# Copyright 2012 SAS Institute
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#
# Read configuration files for mapping Git repositories to CVS locations
# for synchronization, including branch mappings.  Format is ini-style:
# basename of git repositories must be unique

import config
import os
import shlex

class RepositoryConfig(config.Config):
    def __init__(self, configFileName):
        config.Config.__init__(self, configFileName)
        # enforce uniqueness
        self.repos = {}
        for r in self.getRepositories():
            name = self.getRepositoryName(r)
            if name in self.repos:
                raise KeyError('Duplicate repository name %s: %s and %s'
                               %(name, self.repos[name], r))
            self.repos[name] = r
        self.requireAbsolutePaths('skeleton')

    def getRepositories(self):
        return set(self.sections()) - set(('GLOBAL',))

    @staticmethod
    def getRepositoryName(repository):
        return os.path.basename(repository)

    def getRepositoryByName(self, repositoryName):
        if self.has_section(repositoryName):
            return repositoryName
        return self.repos[repositoryName]

    def getCVSRoot(self, repository):
        return self.getGlobalFallback(repository, 'cvsroot')

    def getGitRef(self, repository):
        gitroot = self.getGlobalFallback(repository, 'gitroot')
        # this test needs to handle more cases
        if gitroot.startswith('/') or '://' in gitroot:
            # directory paths, http/s
            return '/'.join((gitroot, repository))
        # username@host:path
        return ':'.join((gitroot, repository))

    def getCVSPath(self, repository):
        return self.get(repository, 'cvspath')

    def getSkeleton(self, repository):
        return self.getGlobalFallback(repository, 'skeleton', error=False)

    def getBranchFrom(self, repository):
        return self.getOptional(repository, 'branchfrom')

    def getBranchPrefix(self, repository, branch):
        optname = 'prefix.'+branch
        return self.getOptional(repository, optname)

    def getGitLogOptions(self, repository, branch):
        optname = 'gitlog.'+branch
        return self.getOptional(repository, optname)

    def getImportBranchMaps(self, repository):
        'return: [(cvsbranch, gitbranch), ...]'
        return [(x[4:], 'cvs-' + self.get(repository, x))
                 for x in sorted(self.options(repository))
                 if x.startswith('cvs.')]

    def getCVSVariables(self, repository):
        'return: ["VARIABLE=value", ...]'
        return ['='.join((x[7:], '' + self.getGlobalFallback(repository, x)))
                for x in sorted(set(self.options(repository) +
                                    self.options('GLOBAL')))
                if x.startswith('cvsvar.')]

    def getExportBranchMaps(self, repository):
        'return: [(gitbranch, cvsbranch, exportbranch), ...]'
        return [(x[4:], self.get(repository, x), 'export-' + x[4:])
                 for x in sorted(self.options(repository))
                 if x.startswith('git.')]

    def getMergeBranchMaps(self, repository):
        'return: {sourcebranch, set(targetbranch, targetbranch, ...), ...}'
        return dict((x[6:], set(self.get(repository, x).strip().split()))
                    for x in sorted(self.options(repository))
                    if x.startswith('merge.'))

    def getHook(self, type, when, repository):
        return self.getGlobalFallback(repository, when+'hook.'+type, error=False)

    def getHookDir(self, direction, type, when, repository):
        if direction:
            return self.getGlobalFallback(repository, when+'hook.'+direction+'.'+type,
                                   error=False)
        return None

    def getHookBranch(self, type, when, repository, branch):
        return self.getGlobalFallback(repository, when+'hook.'+type+'.'+branch,
                               error=False)

    def getHookDirBranch(self, direction, type, when, repository, branch):
        if direction:
            return self.getGlobalFallback(repository, when+'hook.'+direction+'.'+type+'.'+branch,
                                   error=False)
        return None

    def getHooksBranch(self, type, direction, when, repository, branch):
        return [shlex.split(x) for x in
                (self.getHook(type, when, repository),
                 self.getHookDir(direction, type, when, repository),
                 self.getHookBranch(type, when, repository, branch),
                 self.getHookDirBranch(direction, type, when, repository, branch))
                if x]

    def getGitImpPreHooks(self, repository, branch):
        return self.getHooksBranch('git', 'imp', 'pre', repository, branch)

    def getGitImpPostHooks(self, repository, branch):
        return self.getHooksBranch('git', 'imp', 'post', repository, branch)

    def getGitExpPreHooks(self, repository, branch):
        return self.getHooksBranch('git', 'exp', 'pre', repository, branch)

    def getGitExpPostHooks(self, repository, branch):
        return self.getHooksBranch('git', 'exp', 'post', repository, branch)

    def getCVSPreHooks(self, repository, branch):
        return self.getHooksBranch('cvs', None, 'pre', repository, branch)

    def getCVSPostHooks(self, repository, branch):
        return self.getHooksBranch('cvs', None, 'post', repository, branch)

    def getEmail(self, repository):
        email = self.getGlobalFallback(repository, 'email', error=False)
        if email:
            return email.split()
        return None

    def addEmail(self, repository, addresses):
        if not addresses:
            return
        email = self.getGlobalFallback(repository, 'email', error=False)
        if email:
            email = email.split()
            email.extend(addresses)
            self.set(repository, 'email', ' '.join(email))
        else:
            self.set(repository, 'email', ' '.join(addresses))
