package ch.uzh.ifi.pdeboer.pplib.process.test.stdlib

import java.io.File

import ch.uzh.ifi.pdeboer.pplib.process.entities.{PassableProcessParam, Patch}
import ch.uzh.ifi.pdeboer.pplib.process.stdlib.CollectDecideProcess
import org.junit.{Assert, Before, Test}

/**
 * Created by pdeboer on 05/12/14.
 */
class CollectDecideProcessTest {

	import ch.uzh.ifi.pdeboer.pplib.process.stdlib.CollectDecideProcess._

	@Before
	def rmState(): Unit = {
		new File("state/").delete()
	}


	private val data: Patch = new Patch("test")

	@Test
	def testEachProcessIsCalled: Unit = {
		val (c, d) = (collectProcess, decideProcess)
		val cd: CollectDecideProcess = new CollectDecideProcess(Map(COLLECT.key -> c, DECIDE.key -> d))
		cd.process(data)
		Assert.assertTrue(c.createdProcesses.head.asInstanceOf[CreateSignalingProcess[_, _]].called)
		Assert.assertTrue(d.createdProcesses.head.asInstanceOf[CreateSignalingProcess[_, _]].called)
	}

	@Test
	def testCostCeiling: Unit = {
		val (c, d) = (collectProcess, decideProcess)
		val cd: CollectDecideProcess = new CollectDecideProcess(Map(COLLECT.key -> c, DECIDE.key -> d))
		cd.process(data)

		Assert.assertEquals(1, c.createdProcesses.head.getCostCeiling(data))
		Assert.assertEquals(1, d.createdProcesses.head.getCostCeiling(List(data)))

		Assert.assertEquals(2, cd.getCostCeiling(data))
	}

	@Test
	def testDefaultParam: Unit = {
		val (c, d) = (collectProcess, decideProcess)
		new CollectDecideProcess(Map(COLLECT.key -> c, DECIDE.key -> d)).process(data)
		Assert.assertTrue(c.createdProcesses.head.asInstanceOf[CreateSignalingProcess[_, _]].called)
		Assert.assertTrue(d.createdProcesses.head.asInstanceOf[CreateSignalingProcess[_, _]].called)
	}

	def collectProcess = new PassableProcessParam[CreateSignalingProcess[Patch, List[Patch]]](Map(CreateSignalingProcess.OUTPUT.key -> List("a", "b").map(l => new Patch(l))), Some(new CreateSignalingProcessFactory()))

	def decideProcess = new PassableProcessParam[CreateSignalingProcess[List[Patch], Patch]](Map(CreateSignalingProcess.OUTPUT.key -> new Patch("a")), Some(new CreateSignalingProcessFactory()))
}
