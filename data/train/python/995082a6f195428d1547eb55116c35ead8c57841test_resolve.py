import sys

from enstaller.repository import Repository
from enstaller.tests.common import dummy_repository_package_factory

from ..legacy_requirement import _LegacyRequirement
from ..resolve import Resolve


if sys.version_info[0] == 2:
    import unittest2 as unittest
else:
    import unittest


class TestResolve(unittest.TestCase):
    def _repository_factory(self, packages):
        repository = Repository()
        for p in packages:
            repository.add_package(p)
        return repository

    def test__latest_package_simple(self):
        # Given
        packages = [
            dummy_repository_package_factory("swig", "1.3.40", 1),
            dummy_repository_package_factory("swig", "1.3.40", 2),
            dummy_repository_package_factory("swig", "2.0.1", 1),
        ]
        repository = self._repository_factory(packages)

        # When
        resolver = Resolve(repository)
        latest = resolver._latest_package(
            _LegacyRequirement.from_requirement_string("swig")
        )

        # Then
        self.assertEqual(latest.key, "swig-2.0.1-1.egg")

        # When
        resolver = Resolve(repository)
        latest = resolver._latest_package(
            _LegacyRequirement.from_requirement_string("swigg")
        )

        # Then
        self.assertIsNone(latest)

    def test__latest_package_multiple_python_versions(self):
        # Given
        packages = [
            dummy_repository_package_factory("swig", "1.3.40", 1),
            dummy_repository_package_factory("swig", "1.3.40", 2),
            dummy_repository_package_factory("swig", "2.0.1", 1)
        ]
        repository = self._repository_factory(packages)

        # When
        resolver = Resolve(repository)
        latest = resolver._latest_package(
            _LegacyRequirement.from_requirement_string("swig")
        )

        # Then
        self.assertEqual(latest.key, "swig-2.0.1-1.egg")
