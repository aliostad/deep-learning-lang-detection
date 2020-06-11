package teleporter.integration.cluster

import teleporter.integration.cluster.broker.Broker
import teleporter.integration.cluster.instance.Instance

/**
  * Created by huanwuji on 2016/10/13.
  */
object Boot extends App {
  val Array(mode) = args
  mode match {
    case "broker" ⇒ Broker.main(Array.empty)
    case "instance" ⇒ Instance.main(Array.empty)
    case "local" ⇒
      Broker.main(Array.empty)
      Instance.main(Array.empty)
    case _ ⇒ println("Not recognized mode, Only support broker,instance,local")
  }
}