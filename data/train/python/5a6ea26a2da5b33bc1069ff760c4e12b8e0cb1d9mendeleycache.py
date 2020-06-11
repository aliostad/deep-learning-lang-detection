# Flask imports
from flask import Flask

# App imports
from mendeleycache.routes.fields import FieldsController
from mendeleycache.routes.profiles import ProfilesController
from mendeleycache.routes.documents import DocumentsController
from mendeleycache.routes.cache import CacheController
from mendeleycache.routes.root import RootController
from mendeleycache.config import ServiceConfiguration
from mendeleycache.data.controller import DataController
from mendeleycache.analyzer.controller import AnalysisController
from mendeleycache.crawler.file_crawler import FileCrawler
from mendeleycache.crawler.controller import CrawlController
from mendeleycache.crawler.abstract_crawler import AbstractCrawler
from mendeleycache.config import CacheConfiguration
from mendeleycache.pipeline import PipelineController
from mendeleycache.logging import log


class MendeleyCache(Flask):
    def __init__(self, *args, **kwargs):
        super(MendeleyCache, self).__init__(*args, **kwargs)

        # Read configuration
        self.configuration = ServiceConfiguration()
        self.configuration.load()
        log.info("Configuration has been loaded")

        # Create service controllers
        self.data_controller = DataController(self.configuration.database)
        self.data_controller.assert_schema()
        log.info("Schema has been checked")

        # Create crawler based on configuration
        self.crawler = None
        """:type : AbstractCrawler"""
        if not self.configuration.uses_mendeley:
            log.info("Pipeline uses FileCrawler")
            self.crawler = FileCrawler()
        else:
            from mendeleycache.crawler.sdk_crawler import SDKCrawler
            log.info("Pipeline uses SDKCrawler".format(
                app_id=self.configuration.crawler.app_id,
                app_secret=self.configuration.crawler.app_secret
            ))
            self.crawler = SDKCrawler(
                app_id=self.configuration.crawler.app_id,
                app_secret=self.configuration.crawler.app_secret
            )

        # Create the pipeline
        self.crawl_controller = CrawlController(self.crawler, self.configuration.crawler.research_group)
        self.analysis_controller = AnalysisController()
        self.pipeline_controller = PipelineController(
            data_controller=self.data_controller,
            crawl_controller=self.crawl_controller,
            analysis_controller=self.analysis_controller
        )
        log.info("Pipeline has been initialized")

        # Create the routing controllers
        self.fields_controller = FieldsController(self, self.data_controller)
        self.profiles_controller = ProfilesController(self, self.data_controller, self.configuration.cache)
        self.publications_controller = DocumentsController(self, self.data_controller)
        self.cache_controller = CacheController(self,
                                                self.data_controller,
                                                self.pipeline_controller,
                                                self.configuration)
        self.root_controller = RootController(self, self.data_controller, self.configuration)

        # Register the routes
        self.register_routes()
        log.info("Routes have been registered")
        log.info("MendeleyCache has been initialized")

    def register_routes(self):
        self.fields_controller.register()
        self.profiles_controller.register()
        self.publications_controller.register()
        self.cache_controller.register()
        self.root_controller.register()
