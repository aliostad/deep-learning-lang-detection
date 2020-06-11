package test

import TestTrait.TestTrait03
import TestTrait.Fly
import TestTrait.Glide
import TestTrait.Cry
import TestTrait.Wrong

object Unit_10 {

  def main(args: Array[String]): Unit = {
//    ten_3
//    ten_4
//    ten_5
//    ten_7
//    ten_8
    ten_11
  }
  
  /**
   * 10.3-带有具体实现的特质
   */
  def ten_3 {
    val witch03 = new Witch03()
    witch03.eat("stone")//由特质得到的eat方法
    
    Util.partSplit
  }
  
  /**
   * 10.4-带特质的对象
   */
  def ten_4 {
    //如果实现的特质中有抽象方法则会出错
    val witch04 = new Witch04() with Fly
    witch04.fly("dot")
    
    Util.partSplit
  }
  
  /**
   * 10.5-叠在一起的特质
   */
  def ten_5 {
    //从右往左执行特质，可以用来过滤信息或其他的层级处理
    val witch04 = new Witch04() with Fly with Glide
    witch04.fly("Jack")
    
    Util.partSplit
  }
  
  /**
   * 10.7-当作富接口使用的特质
   */
  def ten_7 {
    val oldMonk = new OldMonk()
    oldMonk.shameless("shameless")
    
    Util.partSplit
  }
  
  /**
   * 10.8-特质中的具体字段
   */
  def ten_8 {
    val oldMonk = new OldMonk()
    println("oldMonk's age is " + oldMonk.age)
    val oldOldMonk = new OldOldMonk()
    println("oldOldMonk's age is " + (oldOldMonk.age+60))//age被当作普通字段继承了
    
    Util.partSplit
  }
  
  /**
   * 10.11-初始化特质中的字段
   */
  def ten_11 {
    //不写out时可以直接初始化
//    val oldMonk = new OldMonk() with Cry {val voice = "haha"}
//    println(oldMonk.voice)
//    Util.barSplit
    
    val oldMonk02 = new {val voice = "hehe"} with OldMonk() with Cry
    println(oldMonk02.voice)
    Util.barSplit
    
//    val oldMonk03 = new OldMonk() with Cry//不行啊，还是提示需要初始化voice
    
    Util.partSplit
  }
  
  /**
   * 10.12-扩展类的特质
   */
  def ten_12 {
    val badThing = new BadThing()
    badThing.printStackTrace()//此处调用的即是Exception的方法，Exception已成为Badthing的超类
  }
  
  /**
   * 10.13-自身类型
   */
  def ten_13 {
    new NullPointerException with Wrong
//    new OldMonk with Wrong //因为不是Exception子类所以不能扩展
  }
}