from __future__ import absolute_import

import os.path
import shutil
import tempfile

from egginst.main import EggInst
from egginst.tests.common import DUMMY_EGG, NOSE_1_2_1, NOSE_1_3_0
from egginst.utils import makedirs
from egginst.vendor.six.moves import unittest


from enstaller.egg_meta import split_eggname
from enstaller.errors import EnpkgError, MissingDependency, NoPackageFound
from enstaller.repository import Repository

from ..core import Solver
from ..request import Request
from ..requirement import Requirement

from enstaller.tests.common import (dummy_installed_package_factory,
                                    dummy_repository_package_factory,
                                    repository_factory)


class TestSolverNoDependencies(unittest.TestCase):
    def setUp(self):
        self.prefix = tempfile.mkdtemp()

    def tearDown(self):
        shutil.rmtree(self.prefix)

    def test_install_simple(self):
        entries = [
            dummy_repository_package_factory("numpy", "1.6.1", 1),
            dummy_repository_package_factory("numpy", "1.8.0", 2),
            dummy_repository_package_factory("numpy", "1.7.1", 2),
        ]

        r_actions = [
            ('install', 'numpy-1.8.0-2.egg')
        ]

        repository = repository_factory(entries)
        installed_repository = Repository._from_prefixes([self.prefix])
        solver = Solver(repository, installed_repository)

        request = Request()
        request.install(Requirement("numpy"))
        actions = solver.resolve(request)

        self.assertEqual(actions, r_actions)

    def test_install_no_egg_entry(self):
        # Given
        entries = [
            dummy_repository_package_factory("numpy", "1.6.1", 1),
            dummy_repository_package_factory("numpy", "1.8.0", 2),
        ]

        repository = repository_factory(entries)
        installed_repository = Repository._from_prefixes([self.prefix])
        solver = Solver(repository, installed_repository)

        request = Request()
        request.install(Requirement("scipy"))

        # When/Then
        with self.assertRaises(NoPackageFound):
            solver.resolve(request)

    def test_install_missing_dependency(self):
        # Given
        entries = [
            dummy_repository_package_factory("numpy", "1.8.0", 2,
                                             dependencies=["MKL 10.3"]),
        ]

        repository = repository_factory(entries)
        installed_repository = Repository._from_prefixes([self.prefix])
        solver = Solver(repository, installed_repository)

        request = Request()
        request.install(Requirement("numpy"))

        # When/Then
        with self.assertRaises(MissingDependency):
            solver.resolve(request)

    def test_remove_actions(self):
        # Given
        repository = Repository()

        for egg in [DUMMY_EGG]:
            egginst = EggInst(egg, self.prefix)
            egginst.install()

        solver = Solver(repository, Repository._from_prefixes([self.prefix]))

        request = Request()
        request.remove(Requirement("dummy"))

        # When
        actions = solver.resolve(request)

        # Then
        self.assertEqual(actions, [("remove", os.path.basename(DUMMY_EGG))])

    def test_remove_non_existing(self):
        # Given
        entries = [
            dummy_repository_package_factory("numpy", "1.6.1", 1),
            dummy_repository_package_factory("numpy", "1.8.0", 2),
        ]

        repository = repository_factory(entries)
        solver = Solver(repository, Repository._from_prefixes([self.prefix]))

        request = Request()
        request.remove(Requirement("numpy"))

        # When/Then
        with self.assertRaises(EnpkgError):
            solver.resolve(request)

    def test_chained_override_update(self):
        """ Test update to package with latest version in lower prefix
        but an older version in primary prefix.
        """
        # Given
        l0_egg = NOSE_1_3_0
        l1_egg = NOSE_1_2_1

        expected_actions = [
            ('remove', os.path.basename(l1_egg)),
            ('install', os.path.basename(l0_egg)),
        ]

        entries = [
            dummy_repository_package_factory(
                *split_eggname(os.path.basename(l0_egg))),
        ]

        repository = repository_factory(entries)

        l0 = os.path.join(self.prefix, 'l0')
        l1 = os.path.join(self.prefix, 'l1')
        makedirs(l0)
        makedirs(l1)

        # Install latest version in l0
        EggInst(l0_egg, l0).install()
        # Install older version in l1
        EggInst(l1_egg, l1).install()

        repository = repository_factory(entries)
        installed_repository = Repository._from_prefixes([l1])
        solver = Solver(repository, installed_repository)

        request = Request()
        request.install(Requirement("nose"))

        # When
        actions = solver.resolve(request)

        # Then
        self.assertListEqual(actions, expected_actions)


class TestSolverDependencies(unittest.TestCase):
    def test_simple(self):
        # Given
        entries = [
            dummy_repository_package_factory("MKL", "10.3", 1),
            dummy_repository_package_factory("numpy", "1.8.0", 2,
                                             dependencies=["MKL 10.3"]),
        ]

        repository = repository_factory(entries)
        installed_repository = Repository()

        expected_actions = [
            ('install', "MKL-10.3-1.egg"),
            ('install', "numpy-1.8.0-2.egg"),
        ]

        request = Request()
        request.install(Requirement("numpy"))

        # When
        solver = Solver(repository, installed_repository)
        actions = solver.resolve(request)

        # Then
        self.assertListEqual(actions, expected_actions)

    def test_simple_installed(self):
        # Given
        entries = [
            dummy_repository_package_factory("MKL", "10.3", 1),
            dummy_repository_package_factory("numpy", "1.8.0", 2,
                                             dependencies=["MKL 10.3"]),
        ]

        repository = repository_factory(entries)
        installed_repository = Repository()
        installed_repository.add_package(
            dummy_installed_package_factory("MKL", "10.3", 1)
        )

        expected_actions = [
            ('install', "numpy-1.8.0-2.egg"),
        ]

        # When
        request = Request()
        request.install(Requirement("numpy"))

        solver = Solver(repository, installed_repository)
        actions = solver.resolve(request)

        # Then
        self.assertListEqual(actions, expected_actions)

    def test_simple_all_installed(self):
        # Given
        entries = [
            dummy_repository_package_factory("MKL", "10.3", 1),
            dummy_repository_package_factory("numpy", "1.8.0", 2,
                                             dependencies=["MKL 10.3"]),
        ]

        repository = repository_factory(entries)

        installed_entries = [
            dummy_installed_package_factory("MKL", "10.3", 1),
            dummy_installed_package_factory("numpy", "1.8.0", 2)
        ]
        installed_repository = Repository()
        for package in installed_entries:
            installed_repository.add_package(package)

        # When
        request = Request()
        request.install(Requirement("numpy"))

        solver = Solver(repository, installed_repository)
        actions = solver.resolve(request)

        # Then
        self.assertListEqual(actions, [])

        # When
        solver = Solver(repository, installed_repository, force=True)
        actions = solver.resolve(request)

        # Then
        self.assertListEqual(actions,
                             [("remove", "numpy-1.8.0-2.egg"),
                              ("install", "numpy-1.8.0-2.egg")])

        # When
        solver = Solver(repository, installed_repository, force=True,
                        forceall=True)
        actions = solver.resolve(request)

        # Then
        self.assertListEqual(actions,
                             [("remove", "numpy-1.8.0-2.egg"),
                              ("remove", "MKL-10.3-1.egg"),
                              ("install", "MKL-10.3-1.egg"),
                              ("install", "numpy-1.8.0-2.egg")])
