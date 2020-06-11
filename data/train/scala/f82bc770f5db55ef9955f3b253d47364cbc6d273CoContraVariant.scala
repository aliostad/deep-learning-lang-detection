package com.knoldus.kip.assignment.ds

class CoContravariant[-S, +T] {

  def write(x: S): T = {
    x match {
      case res: T => res
    }
  }

}

object CoContravariantApplication extends App{

  val a1 = new Animals

  val b1 = new Bird

  val c1 = new Crow

  val p1 = new Parrot

  val s1 = new SmallCrow

  val w1 = new WaterAnimals

  val v1 = new VerySmallCrow

  val q = new CoContravariant[Bird,SmallCrow]

  print("1st :" + q.write(b1))

  //print("2nd :" + q.write(a1)) //Doesn't work

  print("3rd :" + q.write(c1))
  print("4th :" + q.write(s1))
  print("5th :" + q.write(p1))
  print("6th :" + q.write(v1))

  //print("7th :" + q.write(w1)) // Doesn't work
}