package com.samples

import java.io.PrintStream

/**
 * @see https://habrahabr.ru/post/269695/
 *      *********************************
 * Java
 * > String mama = "Jane";
 * > final String papa = "John";
 *
 * Scala
 * > var mama = "Jane"
 * > val papa = "John"
 *
 */
/**
 * @see http://alvinalexander.com/scala/scala-class-examples-constructors-case-classes-parameters
 *      *****************************************************************************************
 * Declaration    Getter?    Setter?
 * -----------    -------    -------
 * var            yes        yes
 * val            yes        no
 * default        no         no
 *
 */

object Main2 extends App {

  /* Пример #1 */
  def dump = "Foo\n"
  def dump(out: PrintStream){ out.print(dump) }
  dump( Console.out )
  dump( Console.err )

  /* Пример #2 */
//  val tuple = (1,"a",true)
  val tuple: (Int, String, Boolean) = (1, "a", true)
  println( tuple _2 )

  /* Пример #3 */
  case class Person (name: String, age: Int)
  var person = new Person("Sasha",23)
  println( person )

}
