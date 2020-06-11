package ilc
package examples

import org.scalameter.api._
import examples._

// Serializability is needed for passing instances to separate JVMs for benchmarking.
trait BenchData extends Serializable {
  /**
    * Subclass obligation: ExampleGenerated instance containing the generated code.
    */
  val example: ExampleGenerated

  import example._

  type Data = InputType
  type Change = DeltaInputType

  /**
    * Subclass obligation: inputs given the size.
    */
  def inputOfSize(n: Int): Data

  /**
    * Subclass obligation: list of descriptions of changes.
    */
  def changeDescriptions: Gen[String]

  /**
    * Subclass obligation: map input size and change description to actual change.
    * (XXX: should use an enum instead of a description for the key).
    */
  def lookupChange(description: String,
                   inputSize: Int,
                   input: InputType,
                   output: OutputType): Change

  case class Datapack(
    oldInput: Data,
    newInput: Data,
    change: Change,
    oldOutput: OutputType)

  // collection sizes
  def base = 1000
  def last = 5000
  def step = 1000
  def sizes: Gen[Int] = Gen.range("n")(base, last, step)

  lazy val inputsOutputsChanges: Gen[Datapack] = for {
    n <- sizes
    description <- changeDescriptions
  } yield {
    val oldInput = inputOfSize(n)
    val oldOutput = program(oldInput)
    val change = lookupChange(description, n, oldInput, oldOutput)
    val newInput = updateInput(change)(oldInput)
    Datapack(oldInput, newInput, change, oldOutput)
  }

  def className: String = example.getClass.getName.stripSuffix("$")

  val derivatives =
    Array(
      ("derivative", derivative),
      ("normalized derivative", normDerivative))
}
