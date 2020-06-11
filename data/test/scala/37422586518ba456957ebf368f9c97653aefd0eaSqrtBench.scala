import scala.collection.parallel.ForkJoinTaskSupport
import scala.collection.parallel.immutable.{ParVector, ParSeq}
import scala.collection.immutable.{Vector, Seq}
import scala.collection.parallel.mutable.ParTrieMap
import scala.collection.concurrent.TrieMap

object SqrtBench extends testing.Benchmark{
		val len = sys.props("length").toInt
		val parLvl = sys.props("par").toInt

		val testing = ParTrieMap[Int,Double]((0 until len) zip ((0 until len) map (_.toDouble)): _*)
		testing.tasksupport = new ForkJoinTaskSupport(new scala.concurrent.forkjoin.ForkJoinPool(parLvl))

	def run{
		for((n,s) <- testing){
			var sqrt = s.toDouble
			var sqrtOld = 0.0
			while(math.abs(sqrt - sqrtOld) > 0.001){
				sqrtOld = sqrt
				sqrt = 0.5 * (sqrtOld + n/sqrtOld)
			}
			testing(n) = sqrt

			assert(math.abs(sqrt - math.sqrt(n)) < 0.01, "The sqrt solved by the babylonian method is wrong: Sqrt of " + n + " is " + sqrt + " and should be " + math.sqrt(n))
		}
	}
}
		
object SqrtBenchSeq extends testing.Benchmark{
	val len = sys.props("length").toInt
	val testing = TrieMap[Int,Double]((0 until len) zip ((0 until len) map (_.toDouble)): _*)

	def run{
		for((n,s) <- testing){
			var sqrt = s.toDouble
			var sqrtOld = 0.0 
			while(math.abs(sqrt - sqrtOld) > 0.001){
				sqrtOld = sqrt
				sqrt = 0.5 * (sqrtOld + n/sqrtOld)
			}
			testing(n) = sqrt

			assert(math.abs(sqrt - math.sqrt(n)) < 0.01, "The sqrt solved by the babylonian method is wrong: Sqrt of " + n + " is " + sqrt + " and should be " + math.sqrt(n))		
		}
	}
}
