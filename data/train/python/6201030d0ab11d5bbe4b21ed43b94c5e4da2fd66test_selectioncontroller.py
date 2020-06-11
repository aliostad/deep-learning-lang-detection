# -*- coding: utf-8 -*-

import unittest
import sys

import audioselector


class TestSelectionController(unittest.TestCase):

    def setUp(self):
        self.controller = audioselector.SelectionController(0, 100)

    def test_create_partition(self):
        self.assertEqual(0, self.controller.create_partition(50))
        self.assertEqual(1, self.controller.create_partition(75))
        self.assertEqual(2, self.controller.create_partition(100))
        self.assertEqual(0, self.controller.create_partition(25))
        self.assertEqual(0, self.controller.create_partition(10))
        self.assertEqual(1, self.controller.create_partition(20))
        self.assertEqual(3, self.controller.create_partition(40))

    def test_get_partitions(self):
        self.assertEqual([], self.controller.get_partitions())
        self.assertEqual(0, self.controller.create_partition(90))
        self.assertEqual([90], self.controller.get_partitions())
        self.assertEqual(0, self.controller.create_partition(10))
        self.assertEqual([10, 90], self.controller.get_partitions())
        self.assertEqual(1, self.controller.create_partition(50))
        self.assertEqual([10, 50, 90], self.controller.get_partitions())
        self.assertEqual(2, self.controller.create_partition(50))
        self.assertEqual([10, 50, 50, 90], self.controller.get_partitions())

    def test_create_partition_out_of_range(self):
        self.assertRaises(ValueError, self.controller.create_partition, -1)
        self.assertRaises(ValueError, self.controller.create_partition, 100.001)

    def test_partition_callbacks(self):
        cbs = []
        self.controller.on_partition_created(lambda i: cbs.append(i))

        self.controller.create_partition(10)
        self.assertEqual([0], cbs)
        self.controller.create_partition(90)
        self.assertEqual([0, 1], cbs)
        self.controller.create_partition(50)
        self.assertEqual([0, 1, 1], cbs)
        self.controller.create_partition(75)
        self.assertEqual([0, 1, 1, 2], cbs)
        self.controller.create_partition(5)
        self.assertEqual([0, 1, 1, 2, 0], cbs)
        self.controller.create_partition(95)
        self.assertEqual([0, 1, 1, 2, 0, 5], cbs)

    def test_remove_partition(self):
        self.controller.create_partition(40)
        self.controller.create_partition(60)
        self.controller.create_partition(20)
        self.controller.create_partition(80)
        self.controller.create_partition(90)
        self.controller.create_partition(66.7)
        self.assertEqual([20, 40, 60, 66.7, 80, 90],
                         self.controller.get_partitions())

        self.assertRaises(IndexError, self.controller.remove_partition, 6)
        self.controller.remove_partition(1)
        self.assertEqual([20, 60, 66.7, 80, 90],
                         self.controller.get_partitions())
        self.controller.remove_partition(4)
        self.assertEqual([20, 60, 66.7, 80],
                         self.controller.get_partitions())
        self.controller.remove_partition(0)
        self.assertEqual([60, 66.7, 80],
                         self.controller.get_partitions())
        self.controller.remove_partition(1)
        self.assertEqual([60, 80],
                         self.controller.get_partitions())
        self.controller.remove_partition(0)
        self.assertEqual([80],
                         self.controller.get_partitions())
        self.controller.remove_partition(0)
        self.assertEqual([],
                         self.controller.get_partitions())
        self.assertRaises(IndexError, self.controller.remove_partition, 0)
        self.assertRaises(IndexError, self.controller.remove_partition, 1)

    def test_create_selection(self):
        # no overlaps
        self.assertEqual(0, self.controller.create_selection(50, 75))
        self.assertEqual(1, self.controller.create_selection(80, 90))
        self.assertEqual(2, self.controller.create_selection(95, 100))
        self.assertEqual(0, self.controller.create_selection(10, 20))

        # order doesn't matter
        self.assertEqual(0, self.controller.create_selection(2, 1))
        self.assertEqual(2, self.controller.create_selection(40, 30))

        # new contained in old
        self.assertEqual(2, self.controller.create_selection(31, 39))
        self.assertEqual(2, self.controller.create_selection(31, 40))
        self.assertEqual(2, self.controller.create_selection(30, 39))
        self.assertEqual(0, self.controller.create_selection(1.1, 1.9))
        self.assertEqual(5, self.controller.create_selection(95, 100))

        # new overlaps old (partially or completely)
        self.assertEqual(0, self.controller.create_selection(0, 1))
        self.assertEqual(5, self.controller.create_selection(91, 96))
        self.assertEqual(1, self.controller.create_selection(19, 22))
        self.assertEqual(2, self.controller.create_selection(29, 41))

    def test_create_selection_out_of_range(self):
        self.assertRaises(ValueError, self.controller.create_selection, -1, 4)
        self.assertRaises(ValueError, self.controller.create_selection, 98, 101)
        self.assertRaises(ValueError, self.controller.create_selection, -1, 101)

    def test_get_selections(self):
        self.assertEqual([], self.controller.get_selections())

        self.assertEqual(0, self.controller.create_selection(40, 60))
        self.assertEqual([(40, 60)],
                         self.controller.get_selections())
        self.assertEqual(1, self.controller.create_selection(70, 80))
        self.assertEqual([(40, 60), (70, 80)],
                         self.controller.get_selections())
        self.assertEqual(0, self.controller.create_selection(20, 30))
        self.assertEqual([(20, 30), (40, 60), (70, 80)],
                         self.controller.get_selections())

        self.assertEqual(0, self.controller.create_selection(25, 35))
        self.assertEqual([(20, 35), (40, 60), (70, 80)],
                         self.controller.get_selections())
        self.assertEqual(2, self.controller.create_selection(65, 70))
        self.assertEqual([(20, 35), (40, 60), (65, 80)],
                         self.controller.get_selections())

        self.assertEqual(1, self.controller.create_selection(39, 61))
        self.assertEqual([(20, 35), (39, 61), (65, 80)],
                         self.controller.get_selections())

        self.assertEqual(0, self.controller.create_selection(21, 34))
        self.assertEqual([(20, 35), (39, 61), (65, 80)],
                         self.controller.get_selections())

    def test_remove_selection(self):
        self.controller.create_selection(10, 15)
        self.controller.create_selection(30, 48)
        self.controller.create_selection(48, 50)
        self.controller.create_selection(56, 57)
        self.controller.create_selection(99, 100)
        self.assertEqual([(10, 15), (30, 50), (56, 57), (99, 100)],
                         self.controller.get_selections())

        self.assertRaises(IndexError, self.controller.remove_selection, 4)
        self.controller.remove_selection(1)
        self.assertEqual([(10, 15), (56, 57), (99, 100)],
                         self.controller.get_selections())
        self.controller.remove_selection(2)
        self.assertEqual([(10, 15), (56, 57)],
                         self.controller.get_selections())
        self.controller.remove_selection(0)
        self.assertEqual([(56, 57)],
                         self.controller.get_selections())
        self.assertRaises(IndexError, self.controller.remove_selection, 1)
        self.controller.remove_selection(0)
        self.assertEqual([], self.controller.get_selections())
        self.assertRaises(IndexError, self.controller.remove_selection, 0)


if __name__ == "__main__":
    unittest.main()
