package ch.uzh.ifi.pdeboer.pplib.process.stdlib

import ch.uzh.ifi.pdeboer.pplib.process.entities._

/**
 * Created by pdeboer on 14/12/14.
 */
@PPLibProcess
class IndexedPatchListScaleProcess(_params: Map[String, Any] = Map.empty) extends CreateProcess[List[Patch], List[Patch]](_params) {

	import ch.uzh.ifi.pdeboer.pplib.process.stdlib.IndexedPatchListScaleProcess._

	override protected def run(data: List[Patch]): List[Patch] = {
		val processType = CHILD_PROCESS.get

		val lowerPriorityParams = params

		data.map(d => {
			val process = processType.create(lowerPriorityParams)
			process.process(d)
		})
	}

	override def expectedParametersBeforeRun: List[ProcessParameter[_]] = List(CHILD_PROCESS)
}

object IndexedPatchListScaleProcess {
	val CHILD_PROCESS = new ProcessParameter[PassableProcessParam[CreateProcess[Patch, Patch]]]("childProcess", None)
}
