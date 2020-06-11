import RPi.GPIO as gpio
import time

class CarController:
        rb = 8
        rf = 10
        lb = 12
        lf = 16

        PWM_FREQUENCY = 50
        pins = None

        directions = {
            'forward': False,
            'backward': False,
            'left': False,
            'right': False
        }
        
        def __init__(self):
            gpio.setmode(gpio.BOARD)
            
            for pin in [CarController.rb, CarController.rf, CarController.lf, CarController.lb]:
                    gpio.setup(pin, gpio.OUT)
                    gpio.output(pin, 0)
                    
            #CarController.pins = {
            #        CarController.rb: gpio.PWM(CarController.rb, CarController.PWM_FREQUENCY),
            #        CarController.rf: gpio.PWM(CarController.rf, CarController.PWM_FREQUENCY),
            #        CarController.lb: gpio.PWM(CarController.lb, CarController.PWM_FREQUENCY),
            #        CarController.lf: gpio.PWM(CarController.lf, CarController.PWM_FREQUENCY)
            #}
             
        def startForward(self, speed=100):
            #CarController.pins[CarController.rf].start(speed)
            #CarController.pins[CarController.lf].start(speed)
            gpio.output(CarController.rf, 1)
            gpio.output(CarController.lf, 1)
            CarController.directions['forward'] = True

        def stopForward(self):
            #CarController.pins[CarController.rf].stop()
            #CarController.pins[CarController.lf].stop()
            gpio.output(CarController.rf, 0)
            gpio.output(CarController.lf, 0)
            if CarController.directions['left']:
                    self.startLeft()
            if CarController.directions['right']:
                    self.startRight()
            if CarController.directions['backward']:
                    self.startBackward()
            CarController.directions['forward'] = False
                
        def forward(self, t, speed=100):
            self.startForward(speed)
            time.sleep(t)
            self.stopForward()
                        

        def startBackward(self, speed=100):
            #CarController.pins[CarController.rb].start(speed)
            #CarController.pins[CarController.lb].start(speed)
            gpio.output(CarController.rb, 1)
            gpio.output(CarController.lb, 1)
            CarController.directions['backward'] = True

        def stopBackward(self):
            #CarController.pins[CarController.rb].stop()
            #CarController.pins[CarController.lb].stop()
            gpio.output(CarController.rb, 0)
            gpio.output(CarController.lb, 0)
            if CarController.directions['left']:
                    self.startLeft()
            if CarController.directions['right']:
                    self.startRight()
            if CarController.directions['forward']:
                    self.startForward()
            CarController.directions['backward'] = False

        def backward(self, t, speed=100):
            self.startBackward(speed)
            time.sleep(t)
            self.stopBackward()
            

        def startLeft(self, speed=100):
            #CarController.pins[CarController.lb].start(speed)
            #CarController.pins[CarController.rf].start(speed)
            gpio.output(CarController.lb, 1)
            gpio.output(CarController.rf, 1)
            CarController.directions['left'] = True

        def stopLeft(self):
            #CarController.pins[CarController.lb].stop()
            #CarController.pins[CarController.rf].stop()
            gpio.output(CarController.lb, 0)
            gpio.output(CarController.rf, 0)
            if CarController.directions['right']:
                    self.startRight()
            if CarController.directions['backward']:
                    self.startBackward()
            if CarController.directions['forward']:
                    self.startForward()
            CarController.directions['left'] = False
            
        def left(self, t, speed=100):
            self.startLeft(speed)
            time.sleep(t)
            self.stopLeft()


        def startRight(self, speed=100):
            #CarController.pins[CarController.rb].start(speed)
            #CarController.pins[CarController.lf].start(speed)
            gpio.output(CarController.rb, 1)
            gpio.output(CarController.lf, 1)
            CarController.directions['right'] = True

        def stopRight(self):
            #CarController.pins[CarController.rb].stop()
            #CarController.pins[CarController.lf].stop()
            gpio.output(CarController.rb, 0)
            gpio.output(CarController.lf, 0)
            if CarController.directions['left']:
                    self.startLeft()
            if CarController.directions['backward']:
                    self.startBackward()
            if CarController.directions['forward']:
                    self.startForward()
            CarController.directions['right'] = False
            
        def right(self, t, speed=100):
            self.startRight(speed)
            time.sleep(t)
            self.stopRight()
            
        def __enter__(self):
            return self

        def __exit__(self, type, value, traceback):
            gpio.cleanup()
