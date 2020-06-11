import Leap, sys,serial

port = "/dev/ttyUSB0"
baud = 9600
run = True

class Listener(Leap.Listener):

    def on_init(self, controller):
        print "Prendido!"

    def on_connect(self, controller):
        print "Connectado!!"

    def on_disconnect(self, controller):
        print "Desconectado"

    def on_exit(self, controller):
        print "Cerrado"

    def on_frame(self, controller):
        print "cuadro\n"
        frame = controller.frame()
       # print "Frame id: %d, timestamp: %d, manos: %d, dedos: %d, herramientas: %d" % (
       # frame.id, frame.timestamp, len(frame.hands), len(frame.fingers), len(frame.tools))


def main():
    ser = serial.Serial(port,baud)
    ser.setRTS(0)

    listener = Listener()
    controller = Leap.Controller()
    controller.add_listener(listener)
    while run:
        ser.write('5')
        print '5'

    controller.remove_listener(listener)
    
if __name__ == "__main__":
    main()