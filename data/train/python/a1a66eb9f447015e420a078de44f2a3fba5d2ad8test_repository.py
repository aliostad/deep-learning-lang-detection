import textwrap
import unittest

from okonomiyaki.versions import EnpkgVersion

from simplesat.constraints import PrettyPackageStringParser
from simplesat.errors import NoPackageFound
from simplesat.package import RepositoryInfo, RepositoryPackageMetadata
from simplesat.repository import Repository


V = EnpkgVersion.from_string


class TestRepository(unittest.TestCase):
    def packages_from_definition(self, packages_definition,
                                 repository_info=None):
        repository_info = repository_info or RepositoryInfo("dummy")
        parser = PrettyPackageStringParser(EnpkgVersion.from_string)

        return [
            RepositoryPackageMetadata(
                parser.parse_to_package(line), repository_info
            )
            for line in packages_definition.splitlines()
        ]

    def test_simple(self):
        # Given
        packages_definition = textwrap.dedent(u"""\
        dummy 1.0.1-1
        dummy_with_appinst 1.0.0-1
        dummy_with_entry_points 1.0.0-1
        dummy_with_proxy 1.3.40-3
        dummy_with_proxy_scripts 1.0.0-1
        dummy_with_proxy_softlink 1.0.0-1
        nose 1.2.1-1
        nose 1.3.0-1
        nose 1.3.0-2\
        """)
        packages = self.packages_from_definition(packages_definition)

        # When
        repository = Repository()

        # Then
        self.assertEqual(len(repository), 0)

        # When
        repository = Repository(packages)

        # Then
        self.assertEqual(len(repository), len(packages))
        self.assertEqual(list(repository), packages)

        # When
        repository = Repository(reversed(packages))

        # Then
        self.assertEqual(len(repository), len(packages))
        self.assertEqual(list(repository), packages)

    def test_update(self):
        # Given
        packages_definition = textwrap.dedent(u"""\
        dummy 1.0.1-1
        dummy_with_appinst 1.0.0-1
        dummy_with_entry_points 1.0.0-1
        dummy_with_proxy 1.3.40-3
        dummy_with_proxy_scripts 1.0.0-1
        dummy_with_proxy_softlink 1.0.0-1
        nose 1.2.1-1
        nose 1.3.0-1
        nose 1.3.0-2\
        """)
        packages = self.packages_from_definition(packages_definition)

        # When
        repository = Repository(packages[:4])

        # Then
        self.assertEqual(len(repository), 4)

        # When
        repository.update(packages[4:])

        # Then
        self.assertEqual(len(repository), len(packages))
        self.assertEqual(list(repository), packages)

    def test_find_package(self):
        # Given
        packages_definition = textwrap.dedent(u"""\
        dummy 1.0.1-1
        dummy_with_appinst 1.0.0-1
        dummy_with_entry_points 1.0.0-1
        dummy_with_proxy 1.3.40-3
        dummy_with_proxy_scripts 1.0.0-1
        dummy_with_proxy_softlink 1.0.0-1
        nose 1.2.1-1
        nose 1.3.0-1
        nose 1.3.0-2\
        """)
        packages = self.packages_from_definition(packages_definition)
        repository = Repository(packages)

        # When
        package = repository.find_package("nose", V("1.3.0-1"))

        # Then
        self.assertEqual(package.name, "nose")
        self.assertEqual(package.version, V("1.3.0-1"))

    def test_find_unavailable_package(self):
        # Given
        packages_definition = textwrap.dedent(u"""\
        dummy 1.0.1-1
        dummy_with_appinst 1.0.0-1
        dummy_with_entry_points 1.0.0-1
        dummy_with_proxy 1.3.40-3
        dummy_with_proxy_scripts 1.0.0-1
        dummy_with_proxy_softlink 1.0.0-1
        nose 1.2.1-1
        nose 1.3.0-1
        nose 1.3.0-2\
        """)
        packages = self.packages_from_definition(packages_definition)
        repository = Repository(packages)

        # When/Then
        with self.assertRaises(NoPackageFound):
            repository.find_package("nose", V("1.4.0-1"))

        repository.find_package("nose", V("1.3.0-1"))
        with self.assertRaises(NoPackageFound):
            repository.find_package("nono", V("1.3.0-1"))

    def test_find_packages(self):
        # Given
        packages_definition = textwrap.dedent(u"""\
        dummy 1.0.1-1
        dummy_with_appinst 1.0.0-1
        dummy_with_entry_points 1.0.0-1
        dummy_with_proxy 1.3.40-3
        dummy_with_proxy_scripts 1.0.0-1
        dummy_with_proxy_softlink 1.0.0-1
        nose 1.3.0-1
        nose 1.2.1-1
        nose 1.3.0-2\
        """)
        packages = self.packages_from_definition(packages_definition)
        repository = Repository(packages)

        r_versions = (V("1.2.1-1"), V("1.3.0-1"), V("1.3.0-2"))

        # When
        packages = repository.find_packages("nose")

        # Then
        self.assertEqual(len(packages), 3)
        self.assertEqual(tuple(p.version for p in packages), r_versions)

        # When
        packages = repository.find_packages("non_existing_package")

        # Then
        self.assertEqual(len(packages), 0)

    def test_contains(self):
        # Given
        repository_info1 = RepositoryInfo("repo1")
        repository_info2 = RepositoryInfo("repo2")

        packages_definition = textwrap.dedent(u"""\
        dummy 1.0.1-1
        dummy_with_appinst 1.0.0-1
        dummy_with_entry_points 1.0.0-1
        dummy_with_proxy 1.3.40-3
        dummy_with_proxy_scripts 1.0.0-1
        dummy_with_proxy_softlink 1.0.0-1
        nose 1.2.1-1
        nose 1.3.0-1
        nose 1.3.0-2\
        """)
        packages = self.packages_from_definition(
            packages_definition, repository_info1
        )
        repository = Repository(packages)

        # When/Then
        for package in repository:
            self.assertTrue(package in repository)

        # Given
        package = RepositoryPackageMetadata._from_pretty_string(
            "dummy 1.0.1-1", RepositoryInfo("another")
        )

        # When/Then
        self.assertFalse(package in repository)

        # Given
        dummy_repository1 = self.packages_from_definition(
            "dummy 1.0.1-1", repository_info1
        )[0]

        dummy_repository2 = self.packages_from_definition(
            "dummy 1.0.1-1", repository_info2
        )[0]

        # When/Then
        self.assertTrue(dummy_repository1 in repository)
        self.assertFalse(dummy_repository2 in repository)

    def test_add_package(self):
        # Given
        repository_info1 = RepositoryInfo("repo1")

        packages_definition = textwrap.dedent(u"""\
        dummy 1.0.1-1
        dummy_with_appinst 1.0.0-1
        dummy_with_entry_points 1.0.0-1
        dummy_with_proxy 1.3.40-3
        dummy_with_proxy_scripts 1.0.0-1
        dummy_with_proxy_softlink 1.0.0-1
        nose 1.2.1-1
        nose 1.3.0-1
        nose 1.3.0-2\
        """)
        packages = self.packages_from_definition(
            packages_definition, repository_info1
        )
        repository = Repository()

        # When
        repository.add_package(packages[0])

        # Then
        self.assertTrue(packages[0] in repository)
        self.assertEqual(len(repository), 1)
        self.assertEqual(list(repository), packages[:1])

    def test_regression_185(self):
        # Given
        repository_info1 = RepositoryInfo("repo1")

        packages_definition = textwrap.dedent(u"""\
        dummy 1.0.1-1
        dummy_with_appinst 1.0.0-1
        dummy_with_entry_points 1.0.0-1
        dummy_with_proxy 1.3.40-3
        dummy_with_proxy_scripts 1.0.0-1
        dummy_with_proxy_softlink 1.0.0-1
        nose 1.2.1-1
        nose 1.3.0-1
        nose 1.3.0-2\
        """)
        packages = self.packages_from_definition(
            packages_definition, repository_info1
        )
        repository = Repository()

        package = packages[0]

        # When
        repository.find_packages(package.name)
        repository.add_package(package)

        # Then
        self.assertTrue(packages[0] in repository)
        self.assertEqual(len(repository), 1)
        self.assertEqual(list(repository), [package])
