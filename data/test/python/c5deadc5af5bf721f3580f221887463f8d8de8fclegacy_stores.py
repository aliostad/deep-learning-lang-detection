import enstaller.repository

from enstaller.repository_info import OldstyleRepositoryInfo
from enstaller.utils import PY_VER


def parse_index(json_dict, store_location, python_version=PY_VER):
    """
    Parse the given json index data and iterate package instance over its
    content.

    Parameters
    ----------
    json_dict: dict
        Parsed legacy json index
    store_location: str
        A label describing where the index is coming from
    python_version: str
        The major.minor string describing the python version. This generator
        will iterate over every package where the python attribute is `null` or
        equal to this string. If python_version == "*", then every package is
        iterated over.
    """
    fake_repository_info = OldstyleRepositoryInfo(store_location)
    return enstaller.repository.parse_index(json_dict,
                                            fake_repository_info,
                                            python_version)


def repository_factory(session, indices):
    """
    Create a repository from legacy indices.

    Parameters
    ----------
    session : Session
        A :py:class:`~enstaller.session.Session` instance.
    indices : list
        Sequence of (index_url, store_name) pairs, e.g. the indices property of
        :py:class:`~enstaller.config.Configuration` instances.

    Note
    ----

    This does not use etag caching nor write anything in sys.stdout. If you
    want to use etag caching, simply do::

        with session.etag():
            repository = repository_factory(session, ...)
    """
    repository = enstaller.repository.Repository()
    for url, store_location in indices:
        resp = session.fetch(url)
        json_data = resp.json()

        for package in parse_index(json_data, store_location):
            repository.add_package(package)
    return repository
