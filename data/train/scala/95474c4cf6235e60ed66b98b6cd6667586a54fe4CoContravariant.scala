class CoContravariantQueue[-S, +T] {

  def write(x: S): T = {
    x match {
      case res: T => res
    }
  }

}

object Queue6 extends App{

  val f1 = new Country

  val fr1 = new State1

  val o1 = new City11

  val a1 = new City12

  val b1 = new ABC

  val v1 = new State2

  val v2 = new XYZ

  val q = new CoContravariantQueue[State1,ABC]

  print("1st :" + q.write(fr1))

  //print("2nd :" + q.write(f1))--This won't work

  print("3rd :" + q.write(o1))
  print("4th :" + q.write(b1))
  print("5th :" + q.write(a1))
  print("6th :" + q.write(v2))

  //print("7th :" + q.write(v1))--This won't work
}