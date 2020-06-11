object Process0 {
 sealed trait Process[I,O] {
   import Process._
   def apply(s: Stream[I]): Stream[O] = this match {
     case Await(recv) => s match {
       case h #:: t => recv(Some(h))(t)
       case xs => recv(None)(xs)
     }
     case Halt() => Stream()
     case Emit(h,t) => h #:: t(s)
   }

   def repeat: Process[I,O] = {
     def go(p: Process[I,O]): Process[I,O] = p match {
       case Halt() => go(this)
       case Await(recv) => Await {
         case None => recv(None)
         case Some(i) => go(recv(Some(i)))
       }
         case Emit(h,t) => Emit(h,go(t))

     }
     go(this)
   }

   def map[O2](f: O => O2): Process[I,O2] = this |> liftOne(f)

   def |>[O2](p2: Process[O,O2]):  Process[I,O2] =  p2 match {
     case Halt() => Halt[I,O2]()
     case Emit(h,t) => Emit(h, this |> t)
     case Await(f) => this match {
       case Await(recv) => Await((i: Option[I]) => recv(i) |> p2)
       case Emit(h,t) => t |> f(Some(h))
       case Halt() => Halt()
     }
   }
  
   def ++(p: => Process[I,O]): Process[I,O] = this match {
     case Await(recv) => Await(recv andThen(_ ++ p))
     case Emit(h,t) => Emit(h,t ++ p)
     case Halt() => Halt()
   }

   def flatMap[O2](f: O => Process[I,O2]): Process[I,O2] = this match {
     case Await(recv) => Await(recv andThen(_ flatMap f))
     case Halt() => Halt()
     case Emit(h,t) => f(h) ++ t.flatMap(f)
   }
 }

 object Process {
   def emit[I,O](o:O, p: Process[I,O] = Halt[I,O]()) = Emit[I,O](o,p)

   def liftOne[I,O](f: I => O): Process[I,O] = Await {
     case Some(i) => Emit(f(i))
     case None => Halt()
   }
   def filter[I](f: I => Boolean): Process[I,I] = Await[I,I] {
     case Some(i) if f(i) => emit(i)
     case _ => Halt()
   }.repeat

   def take[I](n: Int): Process[I,I] = {
     def go(n: Int): Process[I,I] = Await {
       case Some(i) if n > 0 => Emit(i, go(n-1))
       case _ => Halt()
     }
     go(n)
   }

   def drop[I](n: Int): Process[I,I] = {
     def go(n: Int): Process[I,I] = Await {
       case Some(i) => if (n > 0) {
         go(n-1)
     } else {
       Emit(i,go(n))
     }
       case None => Halt()
     }
     go(n)
   }

   def dropWhile[I](f: I => Boolean): Process[I,I] = {
     def go(continueDrop: Boolean): Process[I,I] = Await {
       case Some(i) => if(continueDrop && f(i)) { go(true)
     } else {
       Emit(i,go(false))
     }
       case None => Halt()
     }
     go(true)
   }

   def count[I]: Process[I,Int] = {
     def go(n: Int): Process[I,Int] = Await {
       case Some(i) => Emit(n,go(n+1))
       case None => Halt()
     }
     go(0)
   }

   def mean: Process[Double,Double] = {
     def go(sum: Double,n: Int): Process[Double, Double] = Await {
       case Some(i) => {
         val s = sum + i
         val m = n+1
         Emit(s/m, go(s,m))
       }
       case None => Halt()
     }
     go(0,0)
   }
 }
 case class Halt[I,O]() extends Process[I,O]
 case class Emit[I,O](head: O, tail: Process[I,O] = Halt[I,O]()) extends Process[I,O]
 case class Await[I,O](recv: Option[I] => Process[I,O]) extends Process[I,O]
}
