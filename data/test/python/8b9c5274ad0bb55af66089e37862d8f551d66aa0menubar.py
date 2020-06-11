from PyQt5.QtWidgets import QAction

class menubar():
    def __init__(self, view):
        menu = view.menuBar()

        fileMenu = menu.addMenu('&File')
        viewMenu = menu.addMenu('&View')

        openButton = QAction("&Open", view)
        openButton.triggered.connect(view.open)
        fileMenu.addAction(openButton)

        saveButton = QAction("&Save", view)
        saveButton.triggered.connect(view.save)
        fileMenu.addAction(saveButton)

        saveAsButton = QAction("&Save As", view)
        saveAsButton.triggered.connect(view.saveAs)
        fileMenu.addAction(saveAsButton)

        highlightButton = QAction("&Highlight Inconsistencies", view)
        highlightButton.triggered.connect(view.highlight)
        viewMenu.addAction(highlightButton)
