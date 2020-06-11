""" third-party """
from enum import Enum

# api version
api_version = 'v2'


class ResourceUri(Enum):
    """ """
    ADVERSARIES = '/{0}/groups/adversaries'.format(api_version)
    ATTRIBUTES = '/{0}/groups'.format(api_version)
    DOCUMENTS = '/{0}/groups/documents'.format(api_version)
    EMAILS = '/{0}/groups/emails'.format(api_version)
    FILE_OCCURRENCES = '/{0}/indicators/files'.format(api_version)
    GROUPS = '/{0}/groups'.format(api_version)
    INCIDENTS = '/{0}/groups/incidents'.format(api_version)
    INDICATORS = '/{0}/indicators'.format(api_version)
    OWNERS = '/{0}/owners'.format(api_version)
    SECURITY_LABELS = '/{0}/securityLabels'.format(api_version)
    SIGNATURES = '/{0}/groups/signatures'.format(api_version)
    TAGS = '/{0}/tags'.format(api_version)
    THREATS = '/{0}/groups/threats'.format(api_version)
    VICTIMS = '/{0}/victims'.format(api_version)
