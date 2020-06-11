__author__ = 'kohn'

import unittest

from mendeleycache.analyzer.controller import AnalysisController
from mendeleycache.crawler.controller import CrawlController
from mendeleycache.crawler.file_crawler import FileCrawler
from mendeleycache.data.controller import DataController
from mendeleycache.pipeline import PipelineController
from mendeleycache.config import SQLiteConfiguration
from mendeleycache.logging import log


class TestPipeline(unittest.TestCase):
    def test_execute(self):
        sqlite_in_memory = SQLiteConfiguration("")
        data_controller = DataController(sqlite_in_memory)
        data_controller.run_schema()

        crawler = FileCrawler()
        crawl_controller = CrawlController(crawler, "d0b7f41f-ad37-3b47-ab70-9feac35557cc")

        analysis_controller = AnalysisController()

        pipeline_controller = PipelineController(
            data_controller=data_controller,
            crawl_controller=crawl_controller,
            analysis_controller=analysis_controller
        )

        # Clean run shall not crash
        pipeline_controller.execute()

        # Second run shall not crash either
        pipeline_controller.execute()

        # Third run shall not crash either
        pipeline_controller.execute()


def sample_pipeline(app_id=None, app_secret=None):
    from mendeleycache.crawler.sdk_crawler import SDKCrawler

    sqlite_in_memory = SQLiteConfiguration("")
    data_controller = DataController(sqlite_in_memory)
    data_controller.run_schema()

    crawler = None
    if app_id is None and app_secret is None:
        crawler = FileCrawler()
    else:
        crawler = SDKCrawler(app_id=app_id, app_secret=app_secret)

    crawl_controller = CrawlController(crawler, "d0b7f41f-ad37-3b47-ab70-9feac35557cc")

    analysis_controller = AnalysisController()

    pipeline_controller = PipelineController(
        data_controller=data_controller,
        crawl_controller=crawl_controller,
        analysis_controller=analysis_controller
    )

    # Clean run shall not crash
    pipeline_controller.execute()

    rows = data_controller.engine.execute("SELECT * FROM profile").fetchall()
    print()
    print("Profiles:")
    for row in rows:
        print(row)

    rows = data_controller.engine.execute("SELECT * FROM cache_profile").fetchall()
    print()
    print("Cache profiles:")
    for row in rows:
        print(row)

    rows = data_controller.engine.execute("SELECT id, owner_mendeley_id, title, authors, tags FROM document").fetchall()
    print()
    print("Documents:")
    for row in rows:
        print(row)

    rows = data_controller.engine.execute("SELECT * FROM cache_document").fetchall()
    print()
    print("Cache documents:")
    for row in rows:
        print(row)

    rows = data_controller.engine.execute("SELECT * FROM cache_field").fetchall()
    print()
    print("Cache fields:")
    for row in rows:
        print(row)

    rows = data_controller.engine.execute("SELECT * FROM cache_document_has_cache_field").fetchall()
    print()
    print("LINK: Cache document -> Cache field:")
    for row in rows:
        print(row)

    rows = data_controller.engine.execute("SELECT * FROM cache_profile_has_cache_document").fetchall()
    print()
    print("LINK: Cache profile -> Cache document:")
    for row in rows:
        print(row)

    print()
