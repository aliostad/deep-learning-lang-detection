package com.modelfabric.sparql.util

import java.io.StringWriter

import org.eclipse.rdf4j.model.Model
import org.eclipse.rdf4j.rio.{RDFFormat, Rio}
import org.scalatest.WordSpecLike


trait RdfModelTestUtils extends WordSpecLike {

  /**
    *
    * @param model the [[Model]] to dump
    * @param format the [[RDFFormat]] to use
    */
  def dumpModel(model: Model, format: RDFFormat = RDFFormat.NTRIPLES): Unit = {
    info(">>> Model dump START")
    val writer = new StringWriter()
    Rio.write(model, writer, format)
    info(writer.getBuffer.toString)
    info("<<< Model dump END")
  }
}
