from data_collector import DataCollector
from node import Node
from node_repository import NodeRepository
from stats_repository import StatsRepository

class SeamonServer(object):
    @staticmethod
    def add_node(name, ip_address, port):
        NodeRepository.save(Node(name=name, ip_address=ip_address, port=port))

    @staticmethod
    def list_nodes():
        return NodeRepository.all()

    @staticmethod
    def get_node_stats(node_name):
        node = NodeRepository.by_name(node_name)
        data = DataCollector.get_node_info(node)
        StatsRepository.save_for_node(node, data)

    @staticmethod
    def node_by_name(name):
        return NodeRepository.by_name(name)
