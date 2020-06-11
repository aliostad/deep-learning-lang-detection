package ch.uzh.ifi.pdeboer.pplib.process

import ch.uzh.ifi.pdeboer.pplib.process.entities.{ProcessStub, PassableProcessParam}
import ch.uzh.ifi.pdeboer.pplib.process.recombination.{RecombinedProcessBlueprint, RecombinationVariantProcessXMLExporter}
import ch.uzh.ifi.pdeboer.pplib.util.U
import org.junit.{Assert, Test}

import scala.reflect.ClassTag
import scala.reflect.runtime.universe._

/**
 * Created by pdeboer on 28/11/14.
 */
class ProcessCandidateProcessXMLExporterTest {
	@Test
	def testStringListExport: Unit = {
		val inputDataProcess: List[String] = List("test1", "test2")
		val outputDataProcess: String = "result1"
		val processType = new PassableProcessWithRuns[List[String], String](Map(inputDataProcess -> outputDataProcess))
		val variant = new RecombinedProcessBlueprint(Map("testprocess" -> processType))
		val process = variant.createProcess("testprocess")

		val exporter = new RecombinationVariantProcessXMLExporter(variant) //List is default
		val xmlExport = exporter.transformDataWithExporter(process, process.inputClass.runtimeClass, inputDataProcess)

		Assert.assertEquals("<List><Item>test1</Item><Item>test2</Item></List>",
			U.removeWhitespaces(xmlExport.toString))

		Assert.assertEquals(outputDataProcess, exporter.transformDataWithExporter(process, process.outputClass.runtimeClass, outputDataProcess))
	}

	@Test
	def testStringSetExport: Unit = {
		val inputDataProcess = Set("test1", "test2")
		val outputDataProcess: String = "result1"
		val processType = new PassableProcessWithRuns[Set[String], String](Map(inputDataProcess -> outputDataProcess))
		val variant = new RecombinedProcessBlueprint(Map("testprocess" -> processType))
		val process = variant.createProcess("testprocess")
		val exporter = new RecombinationVariantProcessXMLExporter(variant) //List is default
		val xmlExport = exporter.transformDataWithExporter(process, process.inputClass.runtimeClass, inputDataProcess)

		Assert.assertEquals("<Set><Item>test1</Item><Item>test2</Item></Set>",
			U.removeWhitespaces(xmlExport.toString))

		Assert.assertEquals(outputDataProcess, exporter.transformDataWithExporter(process, process.outputClass.runtimeClass, outputDataProcess))
	}

	@Test
	def testIntListExport: Unit = {
		val inputDataProcess = List(1, 2, 3)
		val outputDataProcess = 3
		val processType = new PassableProcessWithRuns[List[Int], Integer](Map(inputDataProcess -> outputDataProcess))
		val variant = new RecombinedProcessBlueprint(Map("testprocess" -> processType))
		val process = variant.createProcess("testprocess")

		val exporter = new RecombinationVariantProcessXMLExporter(variant) //List is default
		val xmlExport = exporter.transformDataWithExporter(process, process.inputClass.runtimeClass, inputDataProcess)

		Assert.assertEquals("<List><Item>1</Item><Item>2</Item><Item>3</Item></List>",
			U.removeWhitespaces(xmlExport.toString))

		Assert.assertEquals(outputDataProcess, exporter.transformDataWithExporter(process, process.outputClass.runtimeClass, outputDataProcess))
	}


	@Test
	def testMapExport: Unit = {
		val inputDataProcess = Map("key1" -> "value1", "key2" -> "value2")
		val outputDataProcess = 3
		val processType = new PassableProcessWithRuns[Map[String, String], Integer](Map(inputDataProcess -> outputDataProcess))
		val variant = new RecombinedProcessBlueprint(Map("testprocess" -> processType))
		val process = variant.createProcess("testprocess")

		val exporter = new RecombinationVariantProcessXMLExporter(variant) //List is default
		val xmlExport = exporter.transformDataWithExporter(process, process.inputClass.runtimeClass, inputDataProcess)

		Assert.assertEquals("<Map><Item><Key>key1</Key><Value>value1</Value></Item><Item><Key>key2</Key><Value>value2</Value></Item></Map>",
			U.removeWhitespaces(xmlExport.toString))

		Assert.assertEquals(outputDataProcess, exporter.transformDataWithExporter(process, process.outputClass.runtimeClass, outputDataProcess))
	}

	@Test
	def testCompleteExport: Unit = {
		val inputDataProcess: List[String] = List("test1", "test2")
		val outputDataProcess: String = "result1"
		val processType = new PassableProcessWithRuns[List[String], String](Map(inputDataProcess -> outputDataProcess))
		val variant = new RecombinedProcessBlueprint(Map("testprocess" -> processType))
		val process = variant.createProcess("testprocess")

		val exporter = new RecombinationVariantProcessXMLExporter(variant) //List is default
		Assert.assertEquals("<Variant><ProcessExecutions><ProcessExecution><Name>testprocess</Name><Process><Class>ch.uzh.ifi.pdeboer.pplib.process.ProcessCandidateProcessXMLExporterTest$TestProcess</Class><InputClass>scala.collection.immutable.List</InputClass><OutputClass>java.lang.String</OutputClass><Parameters><Parameter><Name>memoizerName</Name><Type>TypeTag[Option[String]]</Type><Value>None</Value><IsSpecified>false</IsSpecified></Parameter><Parameter><Name>storeExecutionResults</Name><Type>TypeTag[Boolean]</Type><Value>true</Value><IsSpecified>false</IsSpecified></Parameter></Parameters></Process><Results><Result><Input><List><Item>test1</Item><Item>test2</Item></List></Input><Output>result1</Output></Result></Results></ProcessExecution></ProcessExecutions></Variant>", U.removeWhitespaces(exporter.xml + ""))
	}

	private class PassableProcessWithRuns[IN, OUT](val runs: Map[IN, OUT])(implicit inputClass: ClassTag[IN], outputClass: ClassTag[OUT], inputType1: TypeTag[IN], outputType1: TypeTag[OUT]) extends PassableProcessParam[TestProcess[IN, OUT]]() {
		override def create(lowerPrioParams: Map[String, Any], higherPrioParams: Map[String, Any]): TestProcess[IN, OUT] = {
			new TestProcess[IN, OUT](runs)
		}
	}

	private class TestProcess[IN, OUT](val runs: Map[IN, OUT])(implicit inputClass: ClassTag[IN], outputClass: ClassTag[OUT], inputType1: TypeTag[IN], outputType1: TypeTag[OUT]) extends ProcessStub[IN, OUT](Map.empty) {
		//not needed. Yes, it's ugly
		override protected def run(data: IN): OUT = ???

		override def results: Map[IN, OUT] = runs
	}

}
