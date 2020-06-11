from five import grok
from opengever.base.interfaces import IReferenceNumber
from opengever.base.reference import BasicReferenceNumber
from opengever.repository.behaviors.referenceprefix import IReferenceNumberPrefix
from opengever.repository.repositoryfolder import IRepositoryFolderSchema
from opengever.repository.repositoryroot import IRepositoryRoot


class RepositoryRootNumber(BasicReferenceNumber):
    """ Reference number generator for the repository root, which just
    adds the seperator-space and is primary required because we wan't
    to traverse over it.
    """
    grok.provides(IReferenceNumber)
    grok.context(IRepositoryRoot)

    ref_type = 'repositoryroot'

    def get_number(self):
        parent_num = self.get_parent_number()
        if parent_num:
            return str(parent_num) + ' '
        return ''


class RepositoryFolderReferenceNumber(BasicReferenceNumber):
    """ Reference number for repository folder
    """
    grok.provides(IReferenceNumber)
    grok.context(IRepositoryFolderSchema)

    ref_type = 'repository'

    def get_local_number(self):
        prefix = IReferenceNumberPrefix(self.context).reference_number_prefix

        return prefix or ''

    def get_repository_number(self):
        numbers = self.get_parent_numbers()

        return self.get_active_formatter().repository_number(numbers)
