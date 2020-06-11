package no.uit.sfb.toolwrapper

import no.uit.sfb.toolabstraction.{ToolContext, ToolAbstraction, ToolFactory}


class ReadWriteMemory extends ToolFactory[ReadWriteInput, ReadWriteOutput] {

  override def apply(toolContext: ToolContext, in: ReadWriteInput):
                    ToolAbstraction[ReadWriteOutput] = new ToolAbstraction[ReadWriteOutput] {

    envPath = toolContext.path

    inputPath = s"${envPath}readWriteInput/"
    outputPath = s"${envPath}readWriteOutput/"

    inputFilePath = s"${inputPath}readWrite.in_${toolContext.index}"
    outputFilePath = s"${outputPath}readWrite.out_${toolContext.index}"

    var inStrings: Seq[String] = Seq.empty[String]

    override def execute(): Int = {
      if(in.inStrings.isEmpty) {
        return EXIT_SUCCESS
      }

      inStrings = in.inStrings

      0
    }

    override def output: ReadWriteOutput = {
      ReadWriteOutput(inStrings)
    }

    override def command: Seq[String] = Seq(toolContext.program)

    override def validateBefore(help: String): Unit = Unit

  }

}
