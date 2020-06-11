package pea

abstract class SimulatedAnnealing[A, R : Ordering] extends Function1[A, A] {
    import scala.Ordering.Implicits._

    def Tmin: Double
    def Tmax: Double
    def Td: Double // [0..1]

    def T(t: Double) = t * Td

    def F(x: A): R  // cost function
    def S(x: A): A  // new state generator

    def P(a: A, b: A, t: Double): Double // lim (t -> 0) = 0 !!!

    def apply(s0: A) = {
        def inner(bestState: A, oldState: A, t: Double): A = {
            if(t < Tmin) oldState
            else {
                val newState = S(oldState)
                val (a,b) = if(F(newState) < F(oldState)){
                    if(F(newState) < F(bestState)) (newState, newState)
                    else (bestState, newState)
                } else if (math.random < P(oldState, newState, t)){
                    (bestState, newState)
                } else {
                    (bestState, oldState)
                }
                inner(a, b, T(t))
            }
        }

        inner(s0, s0, Tmax)
    }

    override def toString = "SA(%f)" format Td
}
