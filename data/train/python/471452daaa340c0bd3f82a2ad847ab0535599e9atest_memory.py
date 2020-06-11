from unittest import TestCase
from memory import RamController
from memory import MemoryController


class RamTests(TestCase):
    def test_create_ram(self):
        ram = RamController(500)
        self.assertEqual(len(ram), 500)

    def test_read_write(self):
        ram = RamController(32)
        ram[0] = 0xFF
        self.assertEqual(ram[0], 0xFF)


class MemoryControllerTests(TestCase):
    def test_register_controller(self):
        ram = RamController(32)
        mem = MemoryController()
        mem.register_controller(ram, 0)
        self.assertIs(mem._memory_map[0].controller, ram)

    def test_get_controller(self):
        ram1 = RamController(32)
        ram2 = RamController(64)
        mem = MemoryController()
        mem.register_controller(ram1, 0)
        mem.register_controller(ram2, 32)
        c = mem._get_controller(15)
        self.assertIs(c.controller, ram1)
        c = mem._get_controller(31)
        self.assertIs(c.controller, ram1)
        c = mem._get_controller(32)
        self.assertIs(c.controller, ram2)
        c = mem._get_controller(95)
        self.assertIs(c.controller, ram2)
        with self.assertRaises(IndexError):
            mem._get_controller(96)

    def test_read_write_byte(self):
        ram = RamController(32)
        mem = MemoryController()
        mem.register_controller(ram, 0)
        mem.write_byte(0x5A, 0)
        self.assertEqual(mem.read_byte(0), 0x5A)

    def test_read_write_word(self):
        ram = RamController(32)
        mem = MemoryController()
        mem.register_controller(ram, 0)
        mem.write_word(0xAA55, 0)
        self.assertEqual(mem.read_word(0), 0xAA55)
