# -*- coding: utf-8 -*-

from repository.topicrepository import TopicRepository

class TopicFacade:
    def __init__(self):
        pass

    def get_data(self,topic_id):
        topic_repository = TopicRepository()
        result = None
        with topic_repository:
            result = topic_repository.get_data(topic_id)
        return result

    def get_all_topic(self):
        topic_repository = TopicRepository()
        result = None
        with topic_repository:
            result = topic_repository.get_all_topic()
        return result