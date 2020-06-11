from lib.gpio_common import GPIO_Common
from lib.util_common import timestamp_hr, ip_str, get_weather
from lib.switch import SwitchController, Action
from lib.display import DisplayController
from lib.settings import tick_delay, display_delay
from time import sleep

#
# YOU MUST Initialize GPIO in BCM mode
#
GPIO_Common.init()

#
# YOU SHOULD refer to the switches by name instead of GPIO number
#
class Switch:
  A = 4
  B = 22
  C = 27
  D = 17

# achtung /!\ global vars /!\ 
weather = get_weather("Matosinhos")
char_test_count = 0

#
# define display routines
#
def display_routine_intro(display_controller):
  display_controller.text(DisplayController.LCD_LINE_1, "Welcome!")
  display_controller.text(DisplayController.LCD_LINE_2, "Buttons do Stuff")

  
def display_routine_scroll(display_controller):
  display_controller.text(DisplayController.LCD_LINE_1, "* NOT A TEST *",)
  display_controller.scroll(DisplayController.LCD_LINE_2, "This is reality", 2)

def display_routine_timestamp(display_controller):
  display_controller.text(DisplayController.LCD_LINE_1, "* DATE TIME * ")
  display_controller.scroll(DisplayController.LCD_LINE_2, timestamp_hr(), 1)

def display_routine_weather(display_controller):
  global weather
  display_controller.text(DisplayController.LCD_LINE_1, "* WEATHER * ")
  display_controller.scroll(DisplayController.LCD_LINE_2, weather, 1)

def display_char_test(display_controller):
  global char_test_count
  display_controller.text(DisplayController.LCD_LINE_1, "* CHAR TEST ")
  display_controller.text(DisplayController.LCD_LINE_2, "%x %s" % (char_test_count, chr(char_test_count)))
  char_test_count = char_test_count + 1
  
  
def display_routine_ip_addresses(display_controller):
  display_controller.text(DisplayController.LCD_LINE_1, "* IP ADDRESSES * ")
  display_controller.scroll(DisplayController.LCD_LINE_2, ip_str(), 2)
    

#
# YOU CAN declare the callback functions explicily
#
def callback_switch_A_released(event, delta):
  display_controller.set_callback(display_routine_timestamp)

def callback_switch_B_released(event, delta):
  display_controller.set_callback(display_routine_ip_addresses)

def callback_switch_C_released(event, delta):
  display_controller.set_callback(display_routine_weather)

def callback_switch_D_released(event, delta):
  display_controller.set_callback(display_char_test)
  
    
def callback_switch_D_held_long(event, delta):
  display_controller.set_callback(display_routine_intro)
  
#
# YOU MUST Initialize a SwitchController object
# YOU CAN Initialize default actions by passing a dictionary to the constructor like this
#
switch_controller = SwitchController({ 
  # YOU CAN assign an anonymous function as a callback for a specific event
  Switch.A : {
    Action.switch_released : callback_switch_A_released
  },

  Switch.B : {
    Action.switch_released : callback_switch_B_released
  },
  
  Switch.C : {
    Action.switch_released : callback_switch_C_released
  },

  Switch.D : {
    Action.switch_released : callback_switch_D_released
  },
  
  Switch.D : {
    Action.switch_held_long: callback_switch_D_held_long
  }
})

#
# YOU MUST Initialize a DisplayController object.
# This one is initialized to run routine every n ms
#
display_controller = DisplayController(display_routine_intro, display_delay)


# YOU MUST call the tick method in the program's main loop
while True:
    switch_controller.tick()
    display_controller.tick()
    sleep(tick_delay)
    
