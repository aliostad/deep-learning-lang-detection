package blender

import scalaz._

import collection.immutable.Stream

/**
  * Created by mariusz on 2/28/16.
  */
class SceneTree

case class TypeProperties (name: String, typeName: String, length: Int, offset: Int)

object Show {
  implicit def IntShow: Show[Int] = new Show[Int] { override def show(i: Int) = i.toString }
  implicit def CharShow: Show[Char] = new Show[Char] { override def show(i: Char) = ""+i }
  implicit def StringShow: Show[String] = new Show[String] { override def show(s: String) = s }

  def ShoutyStringShow: Show[String] = new Show[String] { override def show(s: String) = s.toUpperCase }
  implicit def TypePropertiesShow: Show[TypeProperties] = new Show[TypeProperties] {
    override def show(t: TypeProperties) = t.name+":"+t.typeName+"("+t.length+","+t.offset+")"
  }
}

object SceneTree {
  import scalaz._
  import Scalaz._
  val typeTree: Tree[TypeProperties] = TypeProperties("foo","Foo",4,0).node (
    TypeProperties("bar","Bar",4,0).leaf,
    TypeProperties("foo1","Foo1",4,0).node (
      TypeProperties("bar1","Bar1",4,0).leaf
    )
  )

  def charTree: Tree[Char] = 'P'.node(
    'W'.leaf,
    'A'.node(
      'B'.leaf,
      'C'.leaf
    ),
    'D'.node(
      'E'.leaf,
      'F'.leaf
    )
  )
}

