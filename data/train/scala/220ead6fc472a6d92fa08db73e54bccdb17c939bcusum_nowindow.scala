package com.spark.fjuted

import org.apache.log4j.{Level, Logger}
import org.apache.spark.SparkConf
import org.apache.spark.streaming.{Seconds, State, StateSpec, StreamingContext}

/**
  * Created by rong on 5/24/17.
  */
object cusum_nowindow {
  Logger.getLogger("org.apache.spark").setLevel(Level.FATAL)

  def main(args: Array[String]): Unit ={
    val conf = new SparkConf().setMaster("local[2]").setAppName("Threshold")
    val ssc = new StreamingContext(conf, Seconds(1))
    val lines = ssc.socketTextStream("localhost", 9999)

    ssc.checkpoint("/home/rong/Desktop/Master_Programs/IdeaProjects/checkpoint")

    val pair = lines.map(info => ("SensorID", info))

    val learn = 128
    val UpdateFunction =
      (sensorId: String, row: Option[String],
       state: State[(Double, Double, Double, Double, Long, String, Boolean)]) => {
        // State : 1.Mean, 2.Variance, 3.S_high, 4.S_low, 5.Counter, 6.Status, 7.Timestamp
        val source:String = row.getOrElse(null)
        //val time = source.split(',').take(1)
        //val value = source.split(',').take(2).drop(1).head.toDouble
        val value = source.toDouble

        if(state.exists()) {
          val old_mean = state.get._1
          val old_variance = state.get._2
          val counter = state.get._5

          var window_flag = state.get._7

          val new_mean = old_mean + (value - old_mean) / (counter + 1)
          val new_variance = old_variance + (value - old_mean) * (value - new_mean)

          val old_Sh = state.get._3
          val old_Sl = state.get._4

          val std = Math.sqrt(new_variance / counter)
          val k = std * 0.5
          val new_Sh = Math.max(0.0, old_Sh + value - old_mean - k)
          val new_Sl = Math.min(0.0, old_Sl + value - old_mean + k)


          //println(value)
          //state.update(new_mean, new_variance, new_Sh, new_Sl, counter+1, "normal", time.head)


          val up_event_flag: Boolean = Math.abs(new_Sh) >= Math.abs(4 * std)
          val down_event_flag: Boolean = Math.abs(new_Sl) >= Math.abs(4 * std)

          if (counter >= learn) {
            if (up_event_flag) {
              println("info" + " " + value.toString + " " + "Up_Event")
              state.update(old_mean, old_variance, 0.0, 0.0, counter, "Warning_UpEvent", window_flag)
            }
            else if (down_event_flag) {
              println("info" + " " + value.toString + " " ++ "Down_Event")
              state.update(old_mean, old_variance, 0.0, 0.0, counter, "Warning_DownEvent", window_flag)
            }
            else {
              println("info" + " " + value.toString + " " + "Normal")
              state.update(new_mean, new_variance, new_Sh, new_Sl, counter + 1, "Normal", window_flag)
            }

            if (state.get._5 >= 512) {
              // State : 1.Mean, 2.Variance, 3.S_high, 4.S_low, 5.Counter, 6.Status, 7.Timestamp
              state.update((state.get._1+new_mean)/2, (state.get._2+new_variance)/2, (state.get._3+new_Sh)/2, (state.get._4+new_Sl)/2, 1, "window maintain", window_flag)
              println("window maintain...")
            } //window size

          } //if counter > learning number
          else {
            println(value.toString + "Learning")
            state.update(new_mean, new_variance, 0.0, 0.0, counter + 1, "Learning", false)
          }
        }
        else{
          state.update(value, 0.0, value, 0.0, 1, null, false)
        }//Initial state
      }//UpdateFunction

    // Using mapWithState api to monitor stream data
    val result = pair.mapWithState(StateSpec.function(UpdateFunction)).stateSnapshots()
    // The Output Operation
    result.print

    ssc.start()
    ssc.awaitTermination()
  }//main
}
