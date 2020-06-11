package signalz

/**
  * Created by johnmcgill on 12/9/16.
  */
class StateMutatingProcessor[S, I, O](process: (I, S) => (O, S),
                                           initState: S) {
  val state: S = initState

  val next: I => (O, S) = (i: I) => {
    process(i, state)
  }
}

class StateMutatingProcessorWithModifier[S, I, O](process: (I, S) => (O, S),
                                                       initState: S,
                                                       modify: (I, S) => Unit) {
  val state: S = initState

  val next: I => (O, S) = (i: I) => {
    modify(i, state)
    process(i, state)
  }
}

object StateMutatingProcessor {
  def apply[S, I, O](process: (I, S) => (O, S),
                     initState: S) = new StateMutatingProcessor(process, initState)

  def withModifier[S, I, O](process: (I, S) => (O, S),
                            initState: S,
                            modify: (I, S) => Unit) = new StateMutatingProcessorWithModifier(process, initState, modify)
}