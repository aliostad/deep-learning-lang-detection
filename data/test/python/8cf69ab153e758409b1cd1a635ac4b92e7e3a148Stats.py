#!/usr/bin/env python
# -*- coding: UTF8 -*-

_stats_controller = None

def _get_stats_controller():
    global _stats_controller
    if _stats_controller == None:
        _stats_controller = StatsController()
    return _stats_controller

def results():
    return _get_stats_controller().results()

def increment(item, step=1):
    for i in range(step + 1):
        _get_stats_controller().increment(item)

def _drop_stats_controller():
    # for testing purposes...
    global _stats_controller
    _stats_controller = None

class StatsController:
    def __init__(self):
        self.resolutions = {}

    def results(self):
        return self.resolutions

    def increment(self, item):
        if item in self.resolutions:
            self.resolutions[item] += 1
        else:
            self.resolutions[item] = 1
