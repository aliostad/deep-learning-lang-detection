package tuwien.auto.scalimero.util

trait WriteCallbackHelper[T] {
  class WriteCallback(var fun : T => Unit) {
    def apply(arg : T) = fun(arg)
    def update(newFun : T => Unit) = fun = newFun
    def detach = writeUnsubscribe(this)
  }
  var wcallbacks = List[WriteCallback]()
  
  def writeSubscribe(callback : T => Unit) = {
    val wcallback = new WriteCallback(callback)
    wcallbacks = wcallback :: wcallbacks
    wcallback
  }
  def writeUnsubscribe(callback : WriteCallback) {
    wcallbacks = wcallbacks filterNot (_ == callback)
  }
  def callWrites(value : T) {wcallbacks map {_(value)}}
}
