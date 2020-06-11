package ie.eoin.sample.calculator

import org.specs2.mutable._

class BcSpec extends Specification{
  "processInput" should {
    "process addition" in {
      val result = Bc.processInput("2+2")
      result must_== 4
    }  
    "process subtraction" in {
      val result = Bc.processInput("2-2")
      result must_== 0
    }  
    "process multiplication" in {
      val result = Bc.processInput("2*3")
      result must_== 6
    }  
    "process division" in {
      val result = Bc.processInput("6/3")
      result must_== 2
    }
    "process division for two negative numbers" in {
      val result = Bc.processInput("-6.1/-.3")
      result must_== 20
    }
    "process multiple operations" in {
      val result = Bc.processInput("5*4+2")
      result must_== 22
    }
    "respect operator precedence" in {
      val result = Bc.processInput("5-2+8/4*2")
      result must_== 7
    }
    "should round correctly for division" in {
      val result = Bc.processInput("74/13")
      result must_== 5
    }
    "should handle decimals" in {
      val result = Bc.processInput("72.001+13.0000001")
      result must_== 85.0010001 
    }
    "should handle decimals smaller than one" in {
      val result = Bc.processInput(".25+.25")
      result must_== 0.5
    }
    "should work with negative numbers" in {
      val result = Bc.processInput("2+-3")
      result must_== -1 
    }
    "not choke on spaces" in {
      val result = Bc.processInput(" 2 + 2   ")
      result must_== 4
    }
    "should divide by zero correctly" in {
      Bc.processInput("10/0") must throwA [ArithmeticException];
    }
    "should throw error on invalid input" in {
      Bc.processInput("1*(***!") must throwA [InvalidExpressionException];
    }
  }
}
