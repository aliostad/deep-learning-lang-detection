import unittest
from PyQt4 import QtGui

from models.document import Document
from controllers.documentlist import DocumentListController

class DocumentListControllerTest(unittest.TestCase):

    def add_dict_test(self):
        controller = DocumentListController()
        document = Document()
        
        controller.add(document)
        
        self.assertEquals(document, controller.association.values()[0])
        self.assertTrue(type(controller.association.keys()[0]) == QtGui.QStandardItem)
        
    def add_item_name_test(self):
        controller = DocumentListController()
        document = Document()
        document.path = "/path/to/test.tf"
        
        
        controller.add(document)
        item = controller.association.keys()[0]
        
        self.assertEquals("test.tf", item.text())
        
        
    def add_item_name2_test(self):
        controller = DocumentListController()
        
        document = Document()
        document.path = "/path/to/othertest.tf"
        
        controller.add(document)
        item = controller.association.keys()[0]
        
        self.assertEquals("othertest.tf", item.text())
        
    def remove_item_dict_test(self):
        controller = DocumentListController()
        
        document = Document()
        controller.add(document)
        controller.remove(document)
        
        self.assertEquals(0, len(controller.association))
        
    def remove_item_dict2_test(self):
        controller = DocumentListController()
        
        document = Document()
        document2 = Document()
        controller.add(document)
        controller.add(document2)
        controller.remove(document)
        
        self.assertEquals(1, len(controller.association))
        self.assertTrue(document2 in controller.association.values())
        self.assertFalse(document in controller.association.values())
        
    def remove_item_return_test(self):
        controller = DocumentListController()
        
        document = Document()
        controller.add(document)
        
        document_item = controller.association.items()[0][0]
        removed_item = controller.remove(document)
        
        self.assertEquals(document_item, removed_item)
        
        
    def get_item_from_document_test(self):
        controller = DocumentListController()
        
        document = Document()
        controller.add(document)
        
        item = controller.get_item_from_document(document)
        self.assertEquals(document, controller.association[item])
        
    def change_filename_test(self):
        controller = DocumentListController()
        
        document = Document()
        document.path = "/path/to/othertest.tf"
        
        controller.add(document)
        item = controller.association.keys()[0]
        controller.change_filename(document, "/new/file/name.tf")
        
        self.assertEquals("name.tf", item.text())
