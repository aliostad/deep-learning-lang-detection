# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'manageTransaction.ui'
#
# Created by: PyQt5 UI code generator 5.4.1
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_manageTransaction(object):
    def setupUi(self, manageTransaction):
        manageTransaction.setObjectName("manageTransaction")
        manageTransaction.resize(350, 150)
        manageTransaction.setMinimumSize(QtCore.QSize(350, 150))
        manageTransaction.setMaximumSize(QtCore.QSize(350, 150))
        self.verticalLayout = QtWidgets.QVBoxLayout(manageTransaction)
        self.verticalLayout.setObjectName("verticalLayout")
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.label = QtWidgets.QLabel(manageTransaction)
        self.label.setObjectName("label")
        self.horizontalLayout.addWidget(self.label)
        self.dateEdit = QtWidgets.QDateEdit(manageTransaction)
        self.dateEdit.setObjectName("dateEdit")
        self.horizontalLayout.addWidget(self.dateEdit)
        spacerItem = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem)
        self.label_2 = QtWidgets.QLabel(manageTransaction)
        self.label_2.setObjectName("label_2")
        self.horizontalLayout.addWidget(self.label_2)
        self.categorysBox = QtWidgets.QComboBox(manageTransaction)
        self.categorysBox.setObjectName("categorysBox")
        self.horizontalLayout.addWidget(self.categorysBox)
        self.verticalLayout.addLayout(self.horizontalLayout)
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.label_4 = QtWidgets.QLabel(manageTransaction)
        self.label_4.setObjectName("label_4")
        self.horizontalLayout_2.addWidget(self.label_4)
        self.amountBox = QtWidgets.QDoubleSpinBox(manageTransaction)
        self.amountBox.setMinimum(-100000000.0)
        self.amountBox.setMaximum(100000000.0)
        self.amountBox.setObjectName("amountBox")
        self.horizontalLayout_2.addWidget(self.amountBox)
        spacerItem1 = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_2.addItem(spacerItem1)
        self.verticalLayout.addLayout(self.horizontalLayout_2)
        self.horizontalLayout_3 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_3.setObjectName("horizontalLayout_3")
        self.label_5 = QtWidgets.QLabel(manageTransaction)
        self.label_5.setObjectName("label_5")
        self.horizontalLayout_3.addWidget(self.label_5)
        self.infoEdit = QtWidgets.QLineEdit(manageTransaction)
        self.infoEdit.setObjectName("infoEdit")
        self.horizontalLayout_3.addWidget(self.infoEdit)
        spacerItem2 = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_3.addItem(spacerItem2)
        self.verticalLayout.addLayout(self.horizontalLayout_3)
        spacerItem3 = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.verticalLayout.addItem(spacerItem3)
        self.buttonBox = QtWidgets.QDialogButtonBox(manageTransaction)
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.buttonBox.setStandardButtons(QtWidgets.QDialogButtonBox.Cancel|QtWidgets.QDialogButtonBox.Ok)
        self.buttonBox.setObjectName("buttonBox")
        self.verticalLayout.addWidget(self.buttonBox)

        self.retranslateUi(manageTransaction)
        self.buttonBox.accepted.connect(manageTransaction.accept)
        self.buttonBox.rejected.connect(manageTransaction.reject)
        QtCore.QMetaObject.connectSlotsByName(manageTransaction)

    def retranslateUi(self, manageTransaction):
        _translate = QtCore.QCoreApplication.translate
        manageTransaction.setWindowTitle(_translate("manageTransaction", "Transaction"))
        self.label.setText(_translate("manageTransaction", "Date"))
        self.label_2.setText(_translate("manageTransaction", "Category"))
        self.label_4.setText(_translate("manageTransaction", "Amount"))
        self.label_5.setText(_translate("manageTransaction", "Info"))

