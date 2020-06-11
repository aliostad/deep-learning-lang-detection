package be.cetic.ratchet.reader.combinators

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.scalatest._
import be.cetic.ratchet.reader.ast._
import java.util.logging.{Level, Logger}

import be.cetic.ratchet.reader.helpers._
import be.cetic.ratchet.reader.combinators.CParser
import be.cetic.ratchet.utils
import be.cetic.ratchet.utils.TestUtils

/**
 *
 * @author : dimitri durieux <dimitri.durieux@cetic.be>
 */
@RunWith(classOf[JUnitRunner])
class FunctionAndDeclaration extends FunSuite {

  test("The Parser should Manage global integer declarations") {
    val pattern =
      """
        |signed long int i;
        |signed long int j;
        |signed long int z;
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    TestUtils.compare(lines, unit.toString)
  }

  test("The Parser should Manage function declarations") {
    val pattern =
      """
        |void f1 (signed long int *res){
        |
        |}
      """.stripMargin
    val unit = (new CParser).apply(pattern)

    unit.descendantsOfType[FunDecl]().head.arguments.head match {
      case VarDecl("res",false,false,PointerType(IntType(32,true)),None) =>
      case VarDecl("res",false,false,IntType(32,true),None) =>throw new Exception("bad format")
      case _ => throw new Exception("bad format")
    }

    utils.TestUtils.compare(pattern, unit.toString)
  }

  test("The Parser should Manage function with declarations") {
    val pattern =
      """
        |void f1 (signed long int *res){
        | signed long int i;
        | signed long int j;
        | signed long int z;
        | unsigned long int s;
        |}
      """.stripMargin
    val unit = (new CParser).apply(pattern)
    utils.TestUtils.compare(pattern, unit.toString)
  }

  test("The Parser should Manage multiple functionDeclarations") {
    val pattern =
      """
        |  void add (signed long int a, signed long int b, signed long int *res){
        |
        |  }
        |
        |  void f1 (signed long int *res){
        |
        |  }
        |
        |  void f2 (signed long int argc, signed long int argv, signed long int *res){
        |
        |  }
        |
        |  void f3 (signed long int *argc, signed long int argv){
        |
        |  }
      """.stripMargin
    val unit = (new CParser).apply(pattern)
    utils.TestUtils.compare(pattern, unit.toString)
  }

  test("The Parser should Manage multiple functionDeclarations with call") {
    val pattern =
      """
        |void add (signed long int a, signed long int b, signed long int *res){
        |
        |}
        |
        |void f3 (signed long int argc, signed long int argv){
        | add(0,argc,&argv);
        |}
        |
        |void f2 (signed long int argc, signed long int argv, signed long int *res){
        | f3(argc,argv);
        |}
        |
        |void f1 (signed long int *res){
        | signed long int argc;
        | signed long int argv;
        | f2(argc,argv,res);
        |}
      """.stripMargin
    val unit = (new CParser).apply(pattern)
    utils.TestUtils.compare(pattern, unit.toString)
  }


  test("The Parser should Manage separated declaration and implementation of function") {
    val pattern =
      """
        |void f1 ();
        |void f2 ();
        |void f3 ();
        |
        |void f1 (){
        |}
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    var fundefs = unit.descendantsOfType[FunDecl]();
    var decl = unit.descendantsOfType[VarDecl]().filter(x => x.declaredType match{
      case x:FunctionType => true
      case _ => false
    });
    fundefs.foreach(x => Logger.getLogger(this.getClass.getName).log(Level.INFO,"function decl : " + x.name))
    decl.foreach(x => Logger.getLogger(this.getClass.getName).log(Level.INFO,"declaration : " + x.name))
    utils.TestUtils.compare(lines, unit.toString)
  }


  test("The Parser should Manage Simple declaration before use") {
    val pattern =
      """
        |
        |void f2 ();
        |
        |void f1 (){
        | f2();
        |}
        |
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    var fundefs = unit.descendantsOfType[FunDecl]();
    var decl = unit.descendantsOfType[VarDecl]().filter(x => x.declaredType match{
      case x:FunctionType => true
      case _ => false
    });
    fundefs.foreach(x => Logger.getLogger(this.getClass.getName).log(Level.INFO,"function decl : " + x.name))
    decl.foreach(x => Logger.getLogger(this.getClass.getName).log(Level.INFO,"declaration : " + x.name))
    utils.TestUtils.compare(lines, unit.toString)
  }


  test("The Parser should Manage function declarations with void parameter") {
    val pattern =
          """
            |void f1 (void){
            |
            |}
          """.stripMargin

    val expected =
      """
        |void f1 (){
        |
        |}
      """.stripMargin

    val unit = (new CParser).apply(pattern)
    utils.TestUtils.compare(expected, unit.toString)
  }


  test("The Parser should Manage pointer to function") {
    val pattern =
      """
        |void f1 (){
        | void (*g)(long int,long int);
        |}
      """.stripMargin

    val unit = (new CParser).apply(pattern)
    val actual = unit.list.head.asInstanceOf[FunDef].instructions.firstInstruction.head.asInstanceOf[FunDecl]
    assert(
      actual.mtype match {
        case PointerType(FunctionType(
          Void(),
          List(VarDecl("",false,false,IntType(32,true),None),VarDecl("",false,false,IntType(32,true),None)))) => true
        case FunctionType(
          PointerType(Void()),
          List(VarDecl("",false,false,IntType(32,true),None),VarDecl("",false,false,IntType(32,true),None))) => true
        //case _ => false
      }
    )

    val parser = new CParser
    val result = parser.parseAll(parser.declaration_specifiers.? ~ parser.declarator,"void (*g) (long int, long int)")

    assert(
      (result.get._1 match {
        case Some(List(StringSpecifier("void")))
             => true
      })
    )
    assert(
        (result.get._2 match {
        case SuffixedDeclarator(
        Identifier("g"),
        List(FunctionDeclaration(x)),
        Some(PointerTemplate(1))
        )
        => true
      })
    )



  }


}
