package main.scala.ex.basic

object Data_Currying2  extends App{
  def judge(right: List[Int], ans: List[Int]) ={
     println("----- judge")
     right.zip(ans).map(pair => pair._1 == pair._2)
  }

  def calc(point: List[Int], right: List[Int], ans: List[Int]) = {
    println("----- calc")
    judge(right,ans).zip(point).map(pair => if (pair._1) pair._2 else 0).sum
  }




  def calcCurried(point: List[Int])( right: List[Int])( ans: List[Int]) = {
    println("----- calcCurried")
    judge(right,ans).zip(point).map(pair => if (pair._1) pair._2 else 0).sum
  }



  def test1(): Unit ={
    println("=== 団体採点処理（関数プロジェクト)")
    val f = (answer: List[Int]) =>
             calc(Data.loadPoint(), Data.loadRight(),answer)
    val ptAll = Data.loadAnswers().map(f)
    println("点数="+ptAll)
    //println("正解=" + Data.loadRight())
    //println("答案=" + Data.loadAnswer())
    //println("配点="+ Data.loadPoint())
    //println("判定="+ judge(Data.loadRight(),Data.loadAnswer()))

  }



  def test2(): Unit = {
    println("=== 団体採点処理（部分適用) ===")
    val f = calc(Data.loadPoint(),Data.loadRight(),_: List[Int])
    val ptAll = Data.loadAnswers().map(f)
    println("点数="+ptAll)
  }

  def test3() ={
    println("=== 団体採点処理(カリー化) ===")
    val f = calcCurried(Data.loadPoint())(Data.loadRight())_
    val ptAll = Data.loadAnswers().map(f)
    println("点数="+ ptAll)
  }

  def test4(): Unit ={
    println("===団体採点処理（変数利用)===")
    val answers =Data.loadAnswers()
    val point = Data.loadPoint()
    val right = Data.loadRight()
    val ptAll = answers.map(answer => calc(point,right,answer))
    println("点数="+ptAll)
  }
  test1()
  test2()
  test3()
  test4()

}