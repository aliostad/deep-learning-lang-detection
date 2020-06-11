package com.ejrav.mi.processor

import com.ejrav.mi.analyzer.AnalyzerFactory
import com.ejrav.mi.config.Collection
import com.ejrav.mi.config.Process
import com.ejrav.mi.source.BasicDocument
import com.ejrav.mi.source.Document

class IndexProcessor(process: Process) extends Processor {
  def run(document: Document, process: Process, collection: Collection): Document = {
    var doc = new BasicDocument

    val analyzer = AnalyzerFactory.getAnalyzer(process.parameters("analyzer"))
    val content = document.field(collection.field.name)

    doc.field(process.outputField, analyzer.tokenize(content.toString))
    collection.tags.foreach(f => doc.field(f.name, f.value))
    doc
  }

  def isReadOnly: Boolean = false

  def close {}
}

object IndexProcessor {
  def apply(process: Process) = {
    new IndexProcessor(process)
  }
}