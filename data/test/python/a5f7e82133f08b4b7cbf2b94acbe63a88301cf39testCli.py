import os

import logging
import unittest

import time

class TestCLI(unittest.TestCase):

    def setUp(self):
        import vbox
        logging.basicConfig(level=logging.DEBUG)
        self.cli = vbox.VBox(['C:\Program Files\Oracle\VirtualBox']).cli

    def test_list_vms(self):
        self.assertIn("hdds", self.cli.manage.list())

    def test_list_vms(self):
        self.assertIn("hdds", self.cli.manage.list())

        for name in self.cli.manage.list():
            handle = getattr(self.cli.manage.list, name)
            handle()

    def test_create_hd_and_info(self):
        name = os.path.realpath("{}_test_create_hd_.vdi".format(self.__class__.__name__))

        self.cli.manage.createHD(name, size=512)
        self.assertTrue(os.path.isfile(name))
        info = self.cli.manage.showHdInfo(name)
        self.assertTrue(info)

        # createHd also registers new hdd in the virtualbox registry.
        for el in self.cli.manage.list.hdds():
            if os.path.realpath(el["Location"]) == name:
                self.cli.manage.closeMedium("disk", name, delete=1)
                break
        else:
            self.fail("Expected for the drive {!r} to be present in the library".format(name))

        self.assertFalse(os.path.exists(name))

    def test_vm_commands(self):
        name = "{}_test_vm_name".format(self.__class__.__name__)

        self.cli.manage.createVM(name, register=["true"])

        # VM should now be listed in the VM list
        for (vmName, uid) in self.cli.manage.list.vms().iteritems():
            if vmName == name:
                break
        else:
            self.fail("VM is not registered")

        self.cli.manage.modifyVM(name, memory="512")
        self.assertEqual(self.cli.manage.showVMInfo(name)["memory"], "512")
        # try starting this VM. Pointless, as there is no bootable mediums. But tests CLI bindings nevertheless.
        self.cli.manage.startVM(name)
        self.cli.manage.controlVM.poweroff(name)
        time.sleep(2)

        self.cli.manage.unregisterVM(name, delete=True)