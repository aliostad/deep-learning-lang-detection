package week5

object reductions {
  def sumOld(xs: List[Int]): Int = xs match {
    case Nil => 0
    case x::xt => x + sumOld(xt)
  }                                               //> sumOld: (xs: List[Int])Int
  sumOld(List(1,2,3,4,5))                         //> res0: Int = 15
    
  def sumR(xs: List[Int]): Int =
    (0 :: xs) reduceLeft (_+_)                    //> sumR: (xs: List[Int])Int
  sumR(List(1,2,3,4,5))                           //> res1: Int = 15
  
  def sumF(xs: List[Int]): Int =
    (xs foldLeft 0)(_+_)                          //> sumF: (xs: List[Int])Int
  sumF(List(1,2,3,4,5))                           //> res2: Int = 15
  
  def prodR(xs: List[Int]): Int =
    (1 :: xs) reduceLeft (_*_)                    //> prodR: (xs: List[Int])Int
  prodR(List(1,2,3,4,5))                          //> res3: Int = 120
  
  def prodF(xs: List[Int]): Int =
    (xs foldLeft 1)(_*_)                          //> prodF: (xs: List[Int])Int
  prodF(List(1,2,3,4,5))                          //> res4: Int = 120
  
  
  def mapFun[T, U](xs: List[T], f: T => U): List[U] =
    (xs foldRight List[U]())(f(_)::_)             //> mapFun: [T, U](xs: List[T], f: T => U)List[U]
  mapFun(List(1,2,3,4,5), (x: Int) => x*5.0)      //> res5: List[Double] = List(5.0, 10.0, 15.0, 20.0, 25.0)
  
  def lengthFun[T](xs: List[T]): Int =
    (xs foldRight 0)((x, y)=>y+1)                 //> lengthFun: [T](xs: List[T])Int
  lengthFun(List(1,2,3,4,5))                      //> res6: Int = 5
}
