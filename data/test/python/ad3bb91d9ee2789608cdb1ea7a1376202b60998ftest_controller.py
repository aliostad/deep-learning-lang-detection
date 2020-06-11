__author__ = 'kohn'

from mendeleycache.crawler.file_crawler import FileCrawler
from mendeleycache.crawler.controller import CrawlController
import unittest


class TestCrawlController(unittest.TestCase):

    def test_crawl_group_members(self):
        """
        Check if the crawler successfully fetches the 22 group members
        :return:
        """
        crwler = FileCrawler()
        crwler_controller = CrawlController(crwler, "d0b7f41f-ad37-3b47-ab70-9feac35557cc")
        self.assertIsNotNone(crwler_controller.members)
        self.assertEqual(len(crwler_controller.members), 0)
        crwler_controller.crawl_group_members()
        self.assertEqual(len(crwler_controller.members), 19)

    def test_crawl_profiles(self):
        """
        Check if the crawler successfully fetches profiles and for all profiles at least an entry in the doc dict
        :return:
        """
        crwler = FileCrawler()
        crwler_controller = CrawlController(crwler, "d0b7f41f-ad37-3b47-ab70-9feac35557cc")
        crwler_controller.crawl_group_members()
        crwler_controller.crawl_profiles()
        self.assertIsNotNone(crwler_controller.profiles)
        self.assertEqual(len(crwler_controller.profiles), 19)
        for member in crwler_controller.members:
            self.assertIn(member.profile_id, crwler_controller.profile_documents)

    def test_crawl_group_documents(self):
        crwler = FileCrawler()
        crwler_controller = CrawlController(crwler, "d0b7f41f-ad37-3b47-ab70-9feac35557cc")
        crwler_controller.crawl_group_members()
        crwler_controller.crawl_group_documents()
        self.assertGreater(len(crwler_controller.group_documents), 0)

    def test_execute(self):
        crwler = FileCrawler()
        crwler_controller = CrawlController(crwler, "d0b7f41f-ad37-3b47-ab70-9feac35557cc")
        crwler_controller.execute()
        self.assertEqual(len(crwler_controller.profiles), 19)
        for member in crwler_controller.members:
            self.assertIn(member.profile_id, crwler_controller.profile_documents)
        self.assertGreater(len(crwler_controller.group_documents), 0)
        self.assertTrue(crwler_controller.succeeded)