package my.scalacheck

import org.scalacheck.Prop.Arg
import org.scalacheck.Test.Status

/**
 * As we've seen, we can test properties or property collections
 * by using the check method.
 *
 * = org.scalacheck.Test.check (or Test.checkProperties, for property collections).
 *   def check(params: Test.Parameters, p: Prop): Test.Result
 **/
object TestExecution {
  /**
   * The Test module is responsible for all test execution in ScalaCheck.
   * It will generate the arguments and evaluate the properties,
   * repeatedly with larger and larger test data
   * (by increasing the size parameter used by the generators).
   *
   * If it doesn't manage to find a failing test case
   * after a certain number of tests, it reports a property as passed.
   */


}
