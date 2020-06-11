package com.scala.st.Test

import java.io.File
import java.net.URL

import scala.io.Source


/**
  * Created by niceday on 17/5/4.
  */
object Chapter9 {
  def main(args: Array[String]): Unit = {
    //读取url内容，只需要一行
    val html = Source.fromURL("http://livest.jumei.com/show/views/manage.jsp#","UTF-8").mkString
    print(html)
    import sys.process._

    //执行shell命令
    "ls -all .."!

    //返回结果  需要!!
    val result = "ls -all .."!!

    print(result)

    //管道需要 ＃｜   写文件需要：  ＃>    #>>  表示从尾部写入数据
    val result1 = "ls -all .." #| "grep g" !!

    print(result1)

    //用文件做为输入
    "grep INFO" #< new File("/Users/niceday/logs/push-binlog.log")!

    //以网络下载做为输入
    "grep body" #< new URL("http://livest.jumei.com/show/views/manage.jsp#")!




  }

}
