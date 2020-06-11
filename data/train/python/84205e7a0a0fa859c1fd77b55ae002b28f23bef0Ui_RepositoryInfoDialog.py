# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file './VCS/RepositoryInfoDialog.ui'
#
# Created: Tue Nov 18 17:53:56 2014
#      by: PyQt5 UI code generator 5.3.2
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_VcsRepositoryInfoDialog(object):
    def setupUi(self, VcsRepositoryInfoDialog):
        VcsRepositoryInfoDialog.setObjectName("VcsRepositoryInfoDialog")
        VcsRepositoryInfoDialog.resize(590, 437)
        VcsRepositoryInfoDialog.setSizeGripEnabled(True)
        self.vboxlayout = QtWidgets.QVBoxLayout(VcsRepositoryInfoDialog)
        self.vboxlayout.setObjectName("vboxlayout")
        self.infoBrowser = QtWidgets.QTextEdit(VcsRepositoryInfoDialog)
        self.infoBrowser.setReadOnly(True)
        self.infoBrowser.setObjectName("infoBrowser")
        self.vboxlayout.addWidget(self.infoBrowser)
        self.buttonBox = QtWidgets.QDialogButtonBox(VcsRepositoryInfoDialog)
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.buttonBox.setStandardButtons(QtWidgets.QDialogButtonBox.Close)
        self.buttonBox.setObjectName("buttonBox")
        self.vboxlayout.addWidget(self.buttonBox)

        self.retranslateUi(VcsRepositoryInfoDialog)
        self.buttonBox.accepted.connect(VcsRepositoryInfoDialog.accept)
        self.buttonBox.rejected.connect(VcsRepositoryInfoDialog.reject)
        QtCore.QMetaObject.connectSlotsByName(VcsRepositoryInfoDialog)

    def retranslateUi(self, VcsRepositoryInfoDialog):
        _translate = QtCore.QCoreApplication.translate
        VcsRepositoryInfoDialog.setWindowTitle(_translate("VcsRepositoryInfoDialog", "Repository Information"))

