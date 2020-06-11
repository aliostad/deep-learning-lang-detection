from led_controller import LEDController
from led_controller.led_world import LEDWorldBuilder
import opc


FC_SERVER = '172.16.20.233:7890'
FC_SERVER = '192.168.2.1:7890'

led_controller = None


def get_led_controller():
    global led_controller
    if led_controller is None:
        world = LEDWorldBuilder().add_octa_circle().build()
        client = opc.Client(FC_SERVER)
        led_controller = LEDController(world, client)
        led_controller.start()
        led_controller.off()
    return led_controller


def teardown_led_controller():
    global led_controller
    if led_controller is not None:
        led_controller.stop()
