package expAbstractData

/** Operation extension 1: An extension of `Base' with a `show' function.
 *  This class needs
 *    - a new root class `Exp' which adds a `show' method to `super.Exp',
 *      the old root class in `Base', 
 *    - a rebinding of the abstract type `exp' to be a subtype of the new root class,
 *    - a new class for numeric literals which adds a `show' method to `super.Num'.
 */
trait Show extends Base {
  type exp <: Exp

  trait Exp extends super.Exp {
    def show: String
  }
  trait Num extends super.Num with Exp {
    def show = value.toString()
  }
  trait Var extends super.Var with Exp{
    def show = sEval
  }  
}

/** Combining operation extension 1 with the data extensions:
 *    - we only need to implement `show' for the two extension classes 
 *      Plus, Neg, Subt, Mult, Div, Bracket .
 */
trait ShowAllOperations extends BaseAllOperations with Show{
  trait Plus extends super.Plus with Exp {
    def show = left.show + "+" + right.show
  }
  trait Neg extends super.Neg with Exp {
    def show = "-(" + operand.show + ")"
  }
  trait Subt extends super.Subt with Exp {
    def show = left.show + "-" + right.show
  }
  trait Mult extends super.Mult with Exp {
    def show = left.show + "*" + right.show
  }
  trait Div extends super.Div with Exp {
    def show = left.show + "/" + right.show
  }
  trait Bracket extends super.Bracket with Exp {
    def show = "(" + operand.show + ")"
  }
}
