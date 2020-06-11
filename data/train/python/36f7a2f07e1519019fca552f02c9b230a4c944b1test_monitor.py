#!/usr/bin/python
# coding=utf-8
###############################################################################
from test import CollectorTestCase
from test import get_collector_config
from test import unittest
from mock import patch

from diamond.collector import Collector
from storm_kafka_monitor import StormKafkaMonitorCollector

from stormkafkamon.processor import (
    PartitionsSummary,
    PartitionState
)

###############################################################################


class TestStormKafkaMonitorCollector(CollectorTestCase):
    def setUp(self):
        config = get_collector_config('StormKafkaMonitorCollector', {
            'interval': 10
        })

        self.collector = StormKafkaMonitorCollector(config, None)

    @patch.object(StormKafkaMonitorCollector, 'get_zk_client')
    def test_running_topologies(self, zk):
        # Running topologies
        zk.return_value.client.get_children.return_value = [
            'foo-1-123123',
            'bar-12-456778',
        ]

        self.assertEqual(['foo', 'bar'], self.collector.running_topologies())

    @patch.object(StormKafkaMonitorCollector, 'get_zk_client')
    def test_metric_name_from_partition_state(self, zk):
        partition_state = PartitionState('broker.local','foo',0,2000,1000,0,'topo',1000,0)
        self.assertEqual(self.collector.metric_name_from_state(partition_state), 'broker.0.foo.')

    @patch.object(StormKafkaMonitorCollector, 'get_zk_client')
    def test_metrics_from_state(self, zk):
        partition_state = PartitionState('broker.i.foo.bar','foo',0,2000,1000,0,'bar',1000,0)
        self.assertEqual(self.collector.metrics_from_partition_state(partition_state), [
            ('broker.0.foo.earliest', 2000),
            ('broker.0.foo.latest', 1000),
            ('broker.0.foo.depth', 0),
            ('broker.0.foo.current', 1000),
            ('broker.0.foo.delta', 0),
        ])

    @patch.object(Collector, 'publish')
    @patch.object(StormKafkaMonitorCollector, 'get_summaries')
    @patch.object(StormKafkaMonitorCollector, 'get_zk_client')
    def test_collect(self, zk, summaries, publish_mock):
        partition_state = PartitionState('broker.local','foo',0,2000,1000,0,'topo',1000,0)
        partition = PartitionsSummary(1,2,1,3,[partition_state])
        summaries.return_value = [('topo', partition)]

        expected_metrics = {
            'topo.total_depth': 1,
            'topo.total_delta': 2,
            'topo.num_partitions': 1,
            'topo.num_brokers': 3,
            'topo.broker.0.foo.earliest': 2000,
            'topo.broker.0.foo.latest': 1000,
            'topo.broker.0.foo.depth': 0,
            'topo.broker.0.foo.current': 1000,
        }

        self.collector.collect()

        self.assertPublishedMany(publish_mock, expected_metrics)

###############################################################################
if __name__ == "__main__":
    unittest.main()
