package chapt18

import chapt18.PathAndAlias.Network

/**
  * Created by zjjfly on 16/7/11.
  */
object SelfType {
  def main(args: Array[String]) {

  }
}

trait Logged {
  def log(msg: String)
}

trait LoggedException extends Logged {
  //自身类型
  this: Exception =>
  def log() {
    log(getMessage)
  }
}
trait NetWorkLog extends Logged {
  //自身类型和复合类型一起用
  this: Network with Serializable=>
  def log() {
    log(join("jj").name)
  }
}

//自身类型不会自动继承,需要重复自身类型声明,不然会报错
trait ManageException extends LoggedException{
  this:Exception=>
}
