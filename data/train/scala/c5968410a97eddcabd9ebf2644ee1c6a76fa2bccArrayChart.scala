package antonkulaga.projects.dynamics

import org.denigma.binding.extensions._
import org.denigma.binding.views.CollectionView
import rx.Rx
import rx.core.Var

import scala.scalajs.js


case class Dimensions(rows: Int, cols: Int, side: Double){

  lazy val vertical = Math.sqrt(Math.pow(side, 2) - Math.pow(side / 2, 2))
}

trait ArrayChart extends CollectionView {

  val dimensions: Rx[Dimensions]

  def makeItem(r: Int, c: Int): Item

  val resize = dimensions.zip

  val items: Var[js.Array[js.Array[Item]]]

  protected def makeRow(old: js.Array[js.Array[Item]], r: Int, cOld: Int, c: Int): js.Array[Item] = if (r >= old.length)
  {
    createRow(r, c)(makeItem)
  }
  else
  {
    val oldRow = old(r)
    val dc = c - cOld
    dc match
    {
      case 0 => oldRow

      case less if less < 0 =>
        for(j <- c to cOld) onRemove(oldRow(j))
        oldRow.slice(0, c)

      case more if more > 0 =>
        val arr =  new js.Array[Item](c)
        for(j <- 0 until cOld) arr(j) = oldRow(j)
        for(j <- cOld until c) {
          val item = makeItem(r, j)
          arr(j) = item
          onInsert(item)
        }
        arr
    }
  }

  protected def createRow(r: Int, c: Int)(fun: (Int, Int) => Item) =
  {
    val row: js.Array[Item] = new js.Array(c)
    for(j <- 0 until c) {
      val item = fun(r, j)
      row(j) = item
      onInsert(item)
    }
    row
  }

  protected def createArray2(r: Int, c: Int)(fun: (Int, Int) => Item): js.Array[js.Array[Item]] = {
    val arr: js.Array[js.Array[Item]] = new js.Array(r)
    for(i <- 0 until r) arr(i) = createRow(i, c)(fun)
    arr
  }

  protected def onResize(oldValue: Dimensions, newValue: Dimensions): Unit =
  {
    //println(s"resizing started with ${oldValue} and ${newValue}")
    (oldValue, newValue) match
    {

      case (oldOne, Dimensions(r, c, _)) if items.now.length == 0 =>
        val arr = createArray2(r, c)(makeItem)
        items.set(arr)

      case (Dimensions(0, 0, _), Dimensions(r, c, _)) =>
        val arr = createArray2(r, c)(makeItem)
        items.set(arr)

      case (Dimensions(rOld, cOld, _), Dimensions(r, c, _)) if rOld == r && cOld ==c =>  // do nothing
      //println("nothing happenz")

      case (Dimensions(rOld, cOld, _), Dimensions(r, c, _)) if rOld == r =>
        //println(s"COLS CHANGED OLD is $cOld and NEW is $c")
        val old = items.now // NOTE: can be dangerious in terms of subscription
        for(i <- 0 until r) old(i) =  makeRow(old, i, cOld, c)
        items.set(old) //nothing changes just something inside mutable old array updates


      case (Dimensions(rOld, cOld, _), Dimensions(r, c, _)) =>
        val old = items.now
        val arr = new js.Array[js.Array[Item]](r)
        //println(s"ROWS CHANGED OLD is $rOld and NEW is $r")
        if(r > rOld) {
          for(i <- 0 until rOld) arr(i) = old(i)
          for(i <- rOld until r) arr(i) = makeRow(old, i, cOld, c)
        }
        else if (r < rOld)
        {
          for(i <- 0 until r) arr(i) = old(i)
          for{
            i <- r until rOld
            item <- old(i)
          } onRemove(item)
        }
        items.set(arr)
    }
  }


  override def subscribeUpdates(): Unit = {
    template.hide()
    resize.onChange("onResize", uniqueValue = true, skipInitial = true)(change => onResize(change._1, change._2))
    println(s"RESEIZE = ${resize.now}")
    onResize(resize.now._1, resize.now._2)
    //val arr = createArray2(d.rows, d.cols)(makeItem)
    //items.set(arr)
  }
}
