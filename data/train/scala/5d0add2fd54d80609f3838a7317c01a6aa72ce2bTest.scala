package com.example.calcbasic

/**
 * Created with IntelliJ IDEA.
 * User: Daisuke
 * Date: 2013/04/06
 * Time: 13:00
 * To change this template use File | Settings | File Templates.
 */
object Test {
  def main(args: Array[String]) {
    val ctrlr = new CalcController
    ctrlr.enter("-")
    ctrlr.dump
    ctrlr.enter("123.45")
    ctrlr.dump
    ctrlr.enter("*678*92513")
    ctrlr.dump
    ctrlr.undo
    ctrlr.dump
    ctrlr.enter("x")
    ctrlr.dump
    ctrlr.enter("911")
    ctrlr.dump
    ctrlr.enter("-")
    ctrlr.dump
    ctrlr.enter("2")
    ctrlr.dump
    ctrlr.enter("/")
    ctrlr.dump
    ctrlr.enter("13")
    ctrlr.dump
    ctrlr.enter("-")
    ctrlr.dump
    ctrlr.enter("/")
    ctrlr.dump
    ctrlr.enter("0")
    ctrlr.dump
    ctrlr.enter(".113")
    ctrlr.dump
    ctrlr.clear
    ctrlr.enter("10-")
    ctrlr.dump
    ctrlr.enter("-")
    ctrlr.dump
    ctrlr.enter("113")
    ctrlr.dump
    ctrlr.enter("-")
    ctrlr.dump
    ctrlr.clear
  }
}
