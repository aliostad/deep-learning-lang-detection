from common.util import Util
from store.controller.StatsController import StatsController

__author__ = 'victor'


class UIStats(object):
  def __init__(self, stats_controller: StatsController):
    self.__stats_controller = stats_controller

  def sort_by_name(self):
    Util.print_list(self.__stats_controller.sort_by_name())

  def sort_by_borrow(self):
    Util.print_list(self.__stats_controller.sort_by_borrow())

  def first_30_percent(self):
    for d in self.__stats_controller.first_30_percent():
      for key, value in d:
        print(key)
        print(value)

  def extra_point(self):
   for d in list(self.__stats_controller.extra_point()):
     print("(" + str(d["name"]) + ", " + str(d["genre"]) + ", " + str(d["rented_count"]) + ")\n")