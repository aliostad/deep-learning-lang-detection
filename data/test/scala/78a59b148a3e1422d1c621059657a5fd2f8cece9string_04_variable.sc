/**
  * 字符串中的变量代换
  */

/**
  * 问题：将变量代换进一个字符串。
  */

/**
  * 解决办法：
  */
//Scala中基础的字符串插值就是在字符串前加字母's'，然后在字符串中放入变量，每个变量都应以'$'字符开头；
val name = "Fred"
val age = 33
val weight = 200.00
println(s"$name is $age years old, and weighs $weight pounds.")  //在字符串前添加字母's'时，其实是创建一个处理字符串字面量；
//在字符串字面量中使用表达式：${}内可嵌入任何表达式；
println(s"Age next year: ${age + 1}")
println(s"You are 33 years old: ${age == 33}")
//打印对象字段的时候使用花括号
case class Student(name:String, score:Int)
val hannah = Student("Hannah", 95)
println(s"${hannah.name} has a score of ${hannah.score}")
//s是一个方法
//字符串插值f（printf格式化）
println(f"$name is $age years old, and weighs $weight%.3f pounds.")
//raw插入符：不会对字符串中的字符进行转义；
s"foo\nbar"
raw"foo\nbar"
//创建自定义插入符。可以自定义插入符，详见Scala字符串插入符的官方文档。

/**
  * 讨论：Scala2.10之前的版本，Scala并不支持上面的字符串插入功能。需要使用字符串的format方法。
  *
  */
val name1 = "Fred"
var age1 = 33
val s = "%s is %d years old".format(name, age)
