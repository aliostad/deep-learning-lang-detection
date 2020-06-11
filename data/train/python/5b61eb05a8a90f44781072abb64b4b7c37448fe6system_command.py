import roslib
roslib.load_manifest('vigir_rqt_system_command')

import rospy
import math

from rqt_gui_py.plugin import Plugin
from python_qt_binding.QtCore import Slot, QAbstractListModel
from python_qt_binding.QtGui import QWidget, QHBoxLayout, QVBoxLayout, QCheckBox, QLabel, QListWidget, QPushButton

from std_msgs.msg import String

class SystemCommandDialog(Plugin):

    def __init__(self, context):
        super(SystemCommandDialog, self).__init__(context)
        self.setObjectName('SystemCommandDialog')

        self.sys_command_pub  = rospy.Publisher('/syscommand',String, None, False, True, None, queue_size=10)

        self._widget = QWidget()
        vbox = QVBoxLayout()
        reset_world_command = QPushButton("Reset World Model")
        reset_world_command.clicked.connect(self.apply_reset_world_command_callback)
        vbox.addWidget(reset_world_command)

        save_octomap = QPushButton("Save Octomap")
        save_octomap.clicked.connect(self.apply_save_octomap_command_callback)
        vbox.addWidget(save_octomap)

        save_pointcloud = QPushButton("Save Pointcloud")
        save_pointcloud.clicked.connect(self.apply_save_pointcloud_command_callback)
        vbox.addWidget(save_pointcloud)

        save_image_left_eye = QPushButton("Save Image Head")
        save_image_left_eye.clicked.connect(self.apply_save_image_left_eye_command_callback)
        vbox.addWidget(save_image_left_eye)

        save_image_left_hand = QPushButton("Save Left Hand Image")
        save_image_left_hand.clicked.connect(self.apply_save_image_left_hand_command_callback)
        vbox.addWidget(save_image_left_hand)

        save_image_right_hand = QPushButton("Save Right Hand Image")
        save_image_right_hand.clicked.connect(self.apply_save_image_right_hand_command_callback)
        vbox.addWidget(save_image_right_hand)

        vbox.addStretch(1)
        self._widget.setLayout(vbox)

        context.add_widget(self._widget)

    def shutdown_plugin(self):
        print "Shutting down ..."
        self.sys_command_pub.unregister()
        print "Done!"

    # Define system command strings
    def apply_reset_world_command_callback(self):
        msg = String("reset")

        print "Send system command = <",msg.data,">"
        self.sys_command_pub.publish(msg)

    def apply_save_octomap_command_callback(self):
        msg = String("save_octomap")

        print "Send system command = <",msg.data,">"
        self.sys_command_pub.publish(msg)

    def apply_save_pointcloud_command_callback(self):
      msg = String("save_pointcloud")

      print "Send system command = <",msg.data,">"
      self.sys_command_pub.publish(msg)

    def apply_save_image_left_eye_command_callback(self):
      msg = String("save_image_left_eye")

      print "Send system command = <",msg.data,">"
      self.sys_command_pub.publish(msg)

    def apply_save_image_left_hand_command_callback(self):
      msg = String("save_image_left_hand")

      print "Send system command = <",msg.data,">"
      self.sys_command_pub.publish(msg)

    def apply_save_image_right_hand_command_callback(self):
      msg = String("save_image_right_hand")

      print "Send system command = <",msg.data,">"
      self.sys_command_pub.publish(msg)

