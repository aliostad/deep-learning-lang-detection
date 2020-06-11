package quickcheck

import common._

import org.scalacheck._
import Arbitrary._
import Gen._
import Prop._

abstract class QuickCheckHeap extends Properties("Heap") with IntHeap {

  property("min") = forAll { a: Int =>
    val h = insert(a, empty)
    findMin(h) == a
  }
  
  property("list") = forAll { (l: List[Int]) =>
    val h = createHeap(l, empty)
    val newList = DumpHeap(h, Nil)
    val expect = l.sorted.reverse
    newList == expect
  }
  
  def createHeap(l: List[Int], h:H) : H = {
    if (l.length == 0) 
      h 
    else
      createHeap(l.drop(1), insert(l.head, h))
  }

  def DumpHeap(h:H, l: List[Int]) : List[Int] = {
    if (isEmpty(h)) 
      l
    else
      DumpHeap(deleteMin(h), findMin(h) :: l)
  }

  implicit lazy val arbHeap: Arbitrary[H] = Arbitrary(genHeap)
 
  lazy val genHeap: Gen[H] = for {
    a <- arbitrary[A]
    h <- frequency((1, const(empty)), (20, genHeap))
  } yield insert(a,h)
}
