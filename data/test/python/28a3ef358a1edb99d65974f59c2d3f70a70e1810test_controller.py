# coding: utf-8


import asyncio

from ami_push.controller import Controller, DEFAULT_MAX_QUEUE_SIZE


def test_basic_controller():
    controller = Controller()
    assert controller.loop == asyncio.get_event_loop()
    assert controller.max_queue_size == DEFAULT_MAX_QUEUE_SIZE
    assert len(controller.queues) == 0


def test_controller_config():
    controller = Controller()
    controller.load_configs(
        filters={"test-filter": {"event": "NoOp"}},
        push_configs=[{"url": "http://foo:bar@baz.com", "filter": "test-filter"}],
    )
    assert controller.filters["test-filter"].rules == {"event": "NoOp"}
    assert controller.pushers[0].filter == "test-filter"
    assert controller.pushers[0].url == "http://foo:bar@baz.com"
