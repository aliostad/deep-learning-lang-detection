from bbpgsql.repository import BBRepository
from bbpgsql.configuration.repository_storage import (
    get_repository_storage_from_config
)


def get_WAL_repository(config):
    repository_type = 'WAL'
    commit_storage = get_repository_storage_from_config(
        config, repository_type)
    return BBRepository(commit_storage)


def get_Snapshot_repository(config):
    repository_type = 'Snapshot'
    commit_storage = get_repository_storage_from_config(
        config, repository_type)
    return BBRepository(commit_storage)
