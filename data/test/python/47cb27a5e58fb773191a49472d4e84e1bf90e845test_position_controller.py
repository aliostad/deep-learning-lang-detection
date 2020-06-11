'''
    test_PositionController.py

    Tests the functionality of thedom/PositionController.py

    Copyright (C) 2015  Timothy Edmund Crosley

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
'''

from thedom.PositionController import PositionController


class TestPositionController(object):

    def setup_method(self, object):
        """
            Creates a position controller containing 50 strings, labeled Item0 - Item49
        """
        self.testList = []
        for count in range(50):
            self.testList.append("Item" + str(count))

        self.positionController = PositionController(items=self.testList, itemsPerPage=5,
                                                     pagesShownAtOnce=4)

    def test_attributes(self):
        """
            Tests to ensure public attributes are set correctly post initialization
        """
        assert self.positionController.pagesShownAtOnce == 4
        assert self.positionController.allItems == self.testList
        assert self.positionController.length == 50
        assert self.positionController.empty == False
        assert self.positionController.itemsPerPage == 5
        assert self.positionController.numberOfPages == 10

        assert self.positionController.startIndex == 0
        assert self.positionController.arePrev == False
        assert self.positionController.areMore == True
        assert self.positionController.page == 0
        assert self.positionController.pageNumber == 1
        assert self.positionController.currentPageItems == ['Item0', 'Item1', 'Item2', 'Item3',
                                                           'Item4']

    def test_setIndex(self):
        """
            Test to ensure changing the page index resets public attributes correctly
        """
        self.positionController.setIndex(5)

        assert self.positionController.startIndex == 5
        assert self.positionController.arePrev == True
        assert self.positionController.areMore == True
        assert self.positionController.page == 1
        assert self.positionController.pageNumber == 2
        assert self.positionController.currentPageItems == ['Item5', 'Item6', 'Item7', 'Item8',
                                                            'Item9']

    def test_nextPage(self):
        """
            Test to ensure incrementing the page updates the positionController correctly
        """
        self.positionController.nextPage()

        assert self.positionController.startIndex == 5
        assert self.positionController.arePrev == True
        assert self.positionController.areMore == True
        assert self.positionController.page == 1
        assert self.positionController.pageNumber == 2
        assert self.positionController.currentPageItems == ['Item5', 'Item6', 'Item7', 'Item8',
                                                            'Item9']

    def test_prevPage(self):
        """
            Test to ensure deincrementing the page updates the positionController correctly
        """
        self.positionController.nextPage()
        self.positionController.prevPage()

        assert self.positionController.startIndex == 0
        assert self.positionController.arePrev == False
        assert self.positionController.areMore == True
        assert self.positionController.page == 0
        assert self.positionController.pageNumber == 1
        assert self.positionController.currentPageItems == ['Item0', 'Item1', 'Item2', 'Item3',
                                                           'Item4']

    def test_setPage(self):
        """
            Test to ensure setting the page updates the positionController correctly
        """

        self.positionController.setPage(3)
        assert self.positionController.startIndex == 15
        assert self.positionController.arePrev == True
        assert self.positionController.areMore == True
        assert self.positionController.page == 3
        assert self.positionController.pageNumber == 4
        assert self.positionController.currentPageItems == ['Item15', 'Item16', 'Item17', 'Item18',
                                                            'Item19']

    def test_pageIndex(self):
        """
            Test to ensure page index correctly maps up to page number
        """
        assert self.positionController.pageIndex(0) ==  0
        assert self.positionController.pageIndex(1) ==  5
        assert self.positionController.pageIndex(2) ==  10
        assert self.positionController.pageIndex(3) ==  15
        assert self.positionController.pageIndex(4) ==  20

    def test_pageList(self):
        """
            Test to ensure pageList method correctly returns page indexes
        """
        pageList = self.positionController.pageList()
        assert len(pageList) == 4
        assert pageList == [0, 5, 10, 15]
