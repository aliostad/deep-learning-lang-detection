package scalax.control;

trait Reference[T]{
  def get : T;
  def set(t : T) : Unit;

  def apply() = get;
  def update(t : T) = set(t);

  def modify(f : T => T) = set(f(get));

  def modifyWith[S](f : T => (T, S)) : S = {
    val (t, s) = f(get);
    set(t);
    s;
  }

  def preserving[S](action : =>S) : S = {
    val oldT = get;

    try { action }
    finally { set(oldT); }
  }

  def withValue[S](t : T)(action : => S) = preserving{
    set(t);
    action;
  }
}

class Ref[T](private[this] var value : T) extends Reference[T]{
  def get = value;
  def set(t : T) = value = t;
}

object Ref{
  def apply[T](t : T) = new Ref(t);
}
