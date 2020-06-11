package myscala.scalaexercises.regular_expressions

import org.junit.Test

class RegexTest {
  @Test
  def regex1() = {
    //业务：用正则表达式将"[1112212,23232]"替换成 1112212,23232 ，即去掉",[,]
    var regex = """[\[\"\]]""".r
    var oldStr = "\"[1112212,23232]\""
    println("替换前的文本:" + oldStr)
    var newStr = regex.replaceAllIn(oldStr, "")
    println("替换后的文本:" + newStr)

    //将"2015/2/12"截取出"2015/2". \d{4}表示4位整数、(/|-)表示是/或者-符号。\d{1,2}表示1到2位整数
    regex = """\d{4}(/|-)\d{1,2}""".r
    val date = "2015/12/2"
    val yearMonth = regex.findFirstIn(date)
    println(yearMonth) //"2015/12

  }
  def main(args: Array[String]) {

  }
}
