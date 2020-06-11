package ff.filters

class Kalman(var processNoiseCov: Double,
             var measurementNoiseCov: Double,
             var estimationErrorCovariance: Double,
             var kalmanGain: Double,
             val initialValue: Double) extends StatefulFilter {

  var x = initialValue

  override def apply(measurement: Double): Double = {
    //prediction update
    processNoiseCov = processNoiseCov + processNoiseCov

    //measurement update
    kalmanGain = processNoiseCov / (processNoiseCov + measurementNoiseCov)
    x = x + kalmanGain * (measurement - x)
    processNoiseCov = (1 - kalmanGain) * processNoiseCov

    x
  }

}
