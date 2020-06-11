import unittest
from Destinations.Destination import Destination
from Destinations.DestinationRepository import DestinationRepository


class TestTemplate(unittest.TestCase):
    def setUp(self):
        self.element_repository = DestinationRepository()

    def test_should_get_nonexistent_element_from_repository(self):
        destination_element = self.element_repository.get_destination_by_id(1)
        self.assertIsInstance(destination_element, Destination)
        self.assertEqual(1, destination_element._element_id)

    def test_should_add_element_int_repository(self):
        new_destination_element = Destination(1)
        self.element_repository.add_destination(new_destination_element)
        element = self.element_repository.get_destination_by_id(1)
        self.assertIs(element, new_destination_element)