import cats.Show
import cats.implicits._

{ // cats provides some predefined implicits for show types
  // usually use import cats.implicits._ to import them all
  import cats.implicits.catsStdShowForInt
  3.show
}

// Show is a type safe version of toString (Really?). since toString is everywhere... we lose the type safety form it
// Show requires the object to have a Show[T] type class instance
// implicit conversions for common types are defined in cats.std.all._
// (Show is a type class here)

// new Object().show // won't pass type checking because there are no implicitly conversion defined for Object

case class Car(model: String)
// Use implicit to add show function to type
// there are two ways of adding show, use Show.fromToString or Show.show
// implicit val carShow = Show.fromToString[Car]
implicit val carShow = Show.show[Car](_.model)
Car("CR-V").show
