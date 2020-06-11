from django.test import TestCase
from rest_framework.test import APIRequestFactory
from api.models import Host, Group, AppStatistics, AppHistory, App
from api.lib.constant import MonitoringStatus

# Create your tests here


class MonitoringTest(TestCase):

    def setUp(self):
        self._init_Host()
        self._init_App()
        self._init_Group()
        self._init_app_history()
        self._init_app_appstatistics()

        self.factory = APIRequestFactory()

    def _init_Host(self):
        Host.create("127.0.0.1", 'local').save()
        Host.create("192.168.26.17", "chengdu_17").save()
        Host.create("192.168.26.16", "chengdu_16").save()

    def _init_Group(self):
        Group.create("source", "Source").save()
        Group.create("solr", "Solr").save()
        Group.create("other", "Other").save()

    def _init_app_appstatistics(self):
        AppStatistics.create('{"count": 1, "id": 1}', 1).save()
        AppStatistics.create('{"count": 2, "id": 1}', 1).save()
        AppStatistics.create('{"count": 3, "id": 1}', 1).save()
        AppStatistics.create('{"count": 1, "id": 1}', 1).save()
        AppStatistics.create('{"count": 2, "id": 1}', 1).save()
        AppStatistics.create('{"count": 3, "id": 1}', 1).save()
        AppStatistics.create('{"count": 1, "id": 1}', 1).save()
        AppStatistics.create('{"count": 2, "id": 1}', 1).save()
        AppStatistics.create('{"count": 1, "id": 1}', 1).save()
        AppStatistics.create('{"count": 3, "id": 1}', 1).save()
        AppStatistics.create('{"count": 1, "id": 1}', 1).save()
        AppStatistics.create('{"count": 4, "id": 1}', 1).save()
        AppStatistics.create('{"count": 4, "id": 1}', 1).save()
        AppStatistics.create('{"count": 4, "id": 1}', 1).save()

    def _init_app_history(self):
        AppHistory.create(1, MonitoringStatus.CRITICAL, "message").save()
        AppHistory.create(1, MonitoringStatus.OK, "message").save()
        AppHistory.create(1, MonitoringStatus.WARN, "message").save()
        AppHistory.create(1, MonitoringStatus.WARN, "message").save()
        AppHistory.create(1, MonitoringStatus.CRITICAL, "message").save()
        AppHistory.create(1, MonitoringStatus.OK, "message").save()
        AppHistory.create(1, MonitoringStatus.WARN, "message").save()
        AppHistory.create(1, MonitoringStatus.OK, "message").save()
        AppHistory.create(1, MonitoringStatus.CRITICAL, "message").save()
        AppHistory.create(1, MonitoringStatus.OK, "message").save()
        AppHistory.create(1, MonitoringStatus.WARN, "message").save()
        AppHistory.create(1, MonitoringStatus.OK, "message").save()
        AppHistory.create(1, MonitoringStatus.OK, "message").save()
        AppHistory.create(1, MonitoringStatus.WARN, "message").save()
        AppHistory.create(1, MonitoringStatus.OK, "message").save()
        AppHistory.create(1, MonitoringStatus.CRITICAL, "message").save()
        AppHistory.create(1, MonitoringStatus.OK, "message").save()

    def _init_App(self):
        App.create("unique_name0", 1, MonitoringStatus.OK, "", 1, 1).save()
        App.create("unique_name1", 2, MonitoringStatus.CRITICAL, "", 1, 1).save()
        App.create("unique_name2", 3, MonitoringStatus.WARN, "", 1, 1).save()
        App.create("unique_name3", 1, MonitoringStatus.OK, "", 1, 1).save()
        App.create("unique_name4", 3, MonitoringStatus.CRITICAL, "", 1, 1).save()
        App.create("unique_name5", 2, MonitoringStatus.OK, "", 1, 1).save()
        App.create("unique_name6", 1, MonitoringStatus.CRITICAL, "", 1, 1).save()
        App.create("unique_name7", 2, MonitoringStatus.OK, "", 1, 1).save()
        App.create("unique_name8", 3, MonitoringStatus.CRITICAL, "", 1, 1).save()
        App.create("unique_name9", 1, MonitoringStatus.OK, "", 1, 1).save()
        App.create("unique_name10", 2, MonitoringStatus.WARN, "", 1, 1).save()
        App.create("unique_name11", 1, MonitoringStatus.OK, "", 1, 1).save()
        App.create("unique_name12", 3, MonitoringStatus.WARN, "", 1, 1).save()
        App.create("unique_name13", 1, MonitoringStatus.OK, "", 1, 1).save()
        App.create("unique_name14", 2, MonitoringStatus.WARN, "", 0, 1).save()
        App.create("unique_name15", 1, MonitoringStatus.OK, "", 0, 1).save()
