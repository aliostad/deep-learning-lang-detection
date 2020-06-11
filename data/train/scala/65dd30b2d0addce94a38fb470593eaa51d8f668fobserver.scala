package utils

trait Value[T] extends {
  def get : T
}

trait Var[T] extends Value[T] {
  def set(newValue: T) : Unit
}

trait Observer[T] {
  def notify (oldVal: T, newVal: T)
}

//A type of variable that can be observed. For example, to get an observable variable holding a float, use 
// var f = new ObservableVar(3.5)
// f.set(4)
// f.get()
sealed class ObservableVar[T] (private var _val: T) extends Var[T]  {
  def get () = _val
  def set (v: T) {
    val old = _val
    _val = v
    observers.foreach(_.notify(old, _val))
  }

  private var observers: List[Observer[T]] = Nil
  def addObserver(observer: Observer[T]) { 
    observers = observer :: observers 
  }
}


// vim: set ts=2 sw=2 et:
