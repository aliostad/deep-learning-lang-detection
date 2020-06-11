package com.logan.feelchakra

import android.util.Log
import scala.concurrent.ExecutionContext.Implicits.global

object ListenerWriter {

  def props(): Props = {
    Props[ListenerWriter]
  }

  case class SetSocket(socket: Socket)
  case class WriteAudioBuffer(path: String, audioBuffer: Array[Byte]) 
  case class WriteAudioDone(path: String)

  case class WriteCurrentTrackPath(path: String)
  case class WritePlayState(playState: PlayState) 

  case class WriteSyncResponse(syncRequestReadTime: Long)

}

import ListenerWriter._

class ListenerWriter extends Actor {

  def receive: Receive = {

    def receiveWrite(socketOutput: OutputStream, dataOutput: DataOutputStream): Receive = {

      def writeSyncResponse(syncRequestReadTime: Long): Unit = {
        try {
          //write messageType 
          dataOutput.writeInt(Reader.SyncResponseMessage)
          dataOutput.flush()

          //write the request read time 
          dataOutput.writeLong(syncRequestReadTime)
          dataOutput.flush()

          //write the current time 
          dataOutput.writeLong(Platform.currentTime)
          dataOutput.flush()

        } catch {
          case e: IOException => 
            Log.d("chakra", "error writing sync result")
            e.printStackTrace()
        }
      }

      def writeCurrentTrackPath(path: String): Unit = {
        Log.d("chakra", "write current track path")

        try {
          //write messageType 
          dataOutput.writeInt(StationReader.TrackPathMessage)
          dataOutput.flush()

          //write data
          dataOutput.writeInt(path.length())
          dataOutput.flush()
          socketOutput.write(path.getBytes())

        } catch {
          case e: IOException => 
            Log.d("chakra", "error writing audioPlayState")
        }
      }

      def writePlayState(playState: PlayState): Unit = {
        Log.d("chakra", "write play state")

        try {

          //write messageType 
          dataOutput.writeInt(StationReader.PlayStateMessage)
          dataOutput.flush()

          //write data
          playState match {
            case Playing(startPos, startTime) => 
              dataOutput.writeInt(1)
              dataOutput.writeInt(startPos)
              dataOutput.writeLong(startTime)
            case NotPlaying => 
              dataOutput.writeInt(0)
          }
          dataOutput.flush()

        } catch {
          case e: IOException => 
            Log.d("chakra", "error writing audioPlayState")
        }
      }

      def writeAudioBuffer(path: String, audioBuffer: Array[Byte]): Unit = {
        try {

          //write messageType 
          dataOutput.writeInt(StationReader.AudioBufferMessage)
          dataOutput.flush()

          //write data
          dataOutput.writeInt(path.length())
          dataOutput.flush()
          socketOutput.write(path.getBytes())

          //write buffer 
          dataOutput.writeInt(audioBuffer.length)
          dataOutput.flush()
          socketOutput.write(audioBuffer, 0, audioBuffer.length)

        } catch {
          case e: IOException => 
            Log.d("chakra", "error writing audioBuffer")
            e.printStackTrace()
        }
      }

      def writeAudioDone(path: String): Unit = {
        Log.d("chakra", "write audio done")

        try {

          //write messageType 
          dataOutput.writeInt(StationReader.AudioDoneMessage)
          dataOutput.flush()

          //write data
          dataOutput.writeInt(path.length())
          dataOutput.flush()
          socketOutput.write(path.getBytes())

        } catch {
          case e: IOException => 
            Log.d("chakra", "error writing audio done")
            e.printStackTrace()
        }
      }

      PartialFunction[Any, Unit] {
        case WriteSyncResponse(syncRequestReadTime) =>
          Log.d("chakra", "writing sync response")
          writeSyncResponse(syncRequestReadTime)

        case WriteAudioBuffer(path, audioBuffer) =>
          writeAudioBuffer(path, audioBuffer)

        case WriteAudioDone(path) =>
          writeAudioDone(path)

        case WriteCurrentTrackPath(path) =>
          writeCurrentTrackPath(path)

        case WritePlayState(playState) =>
          writePlayState(playState)
      }

    }

    PartialFunction[Any, Unit] {
      case SetSocket(socket) =>
        val socketOutput = socket.getOutputStream()
        val dataOutput = new DataOutputStream(socketOutput)
        Log.d("chakra", "setting socket in ListenerWriter")
        context.become(receiveWrite(socketOutput, dataOutput))
    }
  }

}
