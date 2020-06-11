package ch.uzh.ifi.pdeboer.pplib.process.stdlib

import ch.uzh.ifi.pdeboer.pplib.process.entities._

/**
 * Created by pdeboer on 22/12/14.
 */
@PPLibProcess
class FindFixPatchProcess(_params: Map[String, Any] = Map.empty) extends CreateProcess[List[IndexedPatch], List[IndexedPatch]](_params) {

	import ch.uzh.ifi.pdeboer.pplib.process.stdlib.FindFixPatchProcess._

	override protected def run(data: List[IndexedPatch]): List[IndexedPatch] = {
		val memoizer: ProcessMemoizer = getProcessMemoizer(data.hashCode() + "").getOrElse(new NoProcessMemoizer())

		val find = FIND_PROCESS.get.create(higherPrioParams = Map(DefaultParameters.MEMOIZER_NAME.key -> getMemoizerForProcess(FIND_PROCESS.get, "finder")))
		val fixer = FIX_PROCESS.get.create(Map(FixPatchProcess.ALL_DATA.key -> data), Map(DefaultParameters.MEMOIZER_NAME.key -> getMemoizerForProcess(FIX_PROCESS.get, "fixer")))

		val found = memoizer.mem("find")(find.process(data))
		val fixed: Map[Int, IndexedPatch] = memoizer.mem("fix")(
			fixer.process(found)).asInstanceOf[List[IndexedPatch]]
			.map(f => (f.index, f)).toMap

		data.map(d => fixed.getOrElse(d.index, d))
	}

	def getMemoizerForProcess(process: PassableProcessParam[_ <: ProcessStub[_, _]], suffix: String = "") = {
		if (getProcessMemoizer("").isDefined) {
			val memPrefixInParams = process.getParam[Option[String]](
				DefaultParameters.MEMOIZER_NAME.key).flatten
			memPrefixInParams.map(m => m.hashCode + suffix)
		} else None
	}

	override def expectedParametersBeforeRun: List[ProcessParameter[_]] = List(FIND_PROCESS, FIX_PROCESS)

	override def getCostCeiling(data: List[IndexedPatch]): Int = FIND_PROCESS.get.create().getCostCeiling(data) + FIX_PROCESS.get.create().getCostCeiling(data)

}

object FindFixPatchProcess {
	val FIND_PROCESS = new ProcessParameter[PassableProcessParam[DecideProcess[List[Patch], List[Patch]]]]("findProcess", None)
	val FIX_PROCESS = new ProcessParameter[PassableProcessParam[FixPatchProcess]]("fixProcess", None)
}
