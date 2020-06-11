from django.test import TestCase

import requests

from multisites.utils.github import GithubRepository


class GithubUtilsTestCase(TestCase):

    def setUp(self):
        self.username = 'dobestan'
        self.github_repository = GithubRepository(self.username)

        self.valid_github_repository_url = "https://github.com/dobestan/awesome-dobestan"
        self.valid_raw_readme_url = "https://raw.githubusercontent.com/dobestan/awesome-dobestan/master/README.md"

        self.invalid_username = 'invalid_dobestan'
        self.invalid_github_repository = GithubRepository(self.invalid_username)

    def test_get_repository_url(self):
        self.assertEqual(
            self.github_repository.get_repository_url(),
            self.valid_github_repository_url,
        )

    def test_is_repository_valid(self):
        self.assertTrue(
            self.github_repository.is_repository_valid(),
        )
        self.assertFalse(
            self.invalid_github_repository.is_repository_valid(),
        )

    def test_get_raw_readme_url(self):
        raw_readme_url = self.github_repository.get_raw_readme_url()

        self.assertEqual(
            raw_readme_url,
            self.valid_raw_readme_url,
        )

        response = requests.get(raw_readme_url)
        self.assertEqual(
            response.status_code,
            200,
        )

    def test_get_readme_content(self):
        readme_content = self.github_repository.get_readme_content()

        self.assertIsNotNone(
            readme_content,
        )

        self.assertEqual(
            type(readme_content),
            str,
        )
