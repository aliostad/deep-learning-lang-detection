package server

import arduino.Arduino

object Server {
  def main(args: Array[String]) {
      println("Hello, worlD")
      val arduino = new Arduino("cu.usbserial-DA00SVW5", 9600)
      arduino.openConnection()
      var open = arduino.serialRead(1)
      println(open)
      val zero = 0.toChar
      arduino.serialWrite(zero)
      arduino.serialWrite(zero)
      arduino.serialWrite(zero)
      arduino.serialWrite(zero)
      arduino.serialWrite(zero)
      arduino.serialWrite(255.toChar)
      open = arduino.serialRead(1)
      println(open)
      arduino.closeConnection()
   }
}
