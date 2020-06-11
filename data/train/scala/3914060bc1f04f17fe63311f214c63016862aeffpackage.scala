import conf.{ArgsConfig, ProcessOption}
import opt.Operation
import shopee.recognition.entity.{PredictProcess, TrainProcess}

/**
 *
 * @author TuanTA 
 * @since 2017-04-29 22:28
 */
package object shopee {

  /**
    * Generate Process based on asking process's name
    *
    * @param process name of process from config file
    * @param config config parser
    * @return instance of process
    */
  def getProcess(process:String, config:ArgsConfig):Operation = {
    process match {
      case ProcessOption.TRAIN => new TrainProcess(config)
      case ProcessOption.PREDICT => new PredictProcess(config)
    }
  }
}
