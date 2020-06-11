from cotton.scm import SCM

from fabric import api as fab
from fabric.api import env

class Subversion(SCM):

    def svn(self, *commands):
        base = ['svn']
        if 'scm_username' in env and 'scm_password' in env:
            base.append("--username %s" % env.scm_username)
            base.append("--password %s" % env.scm_password)

        commands = ' '.join(base + list(commands))
        fab.run(commands)

    def checkout(self, repository, checkout_to, ref=None):
        if ref:
            repository = "%s@%s" % (repository, ref)

        self.svn('checkout', repository, checkout_to)


    def branch_name(self, repository, output_file=None, append=False):
        pass

    def revision(self, repository, output_file=None, append=False):
        return self._log_state(command=['info | grep "Revision:"'],
                               repository=repository,
                               output_file=output_file,
                               append=append)


    def tag_name(self, repository, output_file=None, append=False):
        pass


    def _log_state(self, command, repository, output_file=None, append=False):
        with fab.cd(repository):
            if output_file:
                redirect = '>'
                if append:
                    redirect = '>>'
                command.extend([redirect, output_file])
            return self.svn(*command)




