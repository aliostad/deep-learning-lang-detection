package com.thoughtstream.audit.process

import org.scalatest.FunSuite
import play.api.libs.json.Json

/**
 *
 * @author Sateesh
 * @since 23/11/2014
 */
class FancyTreeProcessor$Test extends FunSuite {
  test("testDbObjectParsing"){
    val sampleJson = "{\"user\": {\n\t\t\t\"id\":\"pinnamas\",\n\t\t\t\"type\":\"user\",\n\t\t\t\"uid\":\"pinnamas\",\n\t\t\t\"fname\":\"sateesh\",\n\t\t\t\"fname__old\":\"xyz\",\n\t\t\t\"wife\":{\"id\":\"moturia\", \"id__old\":\"abc\", \"type\":\"user\"},\n\t\t\t\"address\":{\"firstLine\":\"\", \"firstLine__old\":\"\", \"postcode\":\"\", \"town\":{\"id\":\"slough\", \"type\": \"town\"}},\n\t\t\t\"yearsInEmployment\":[\"2004\",\"2005\",\"2006\"],\n\t\t\t\"yearsInEmployment_old\":[\"2004\",\"2005\",\"2006\"],\n\t\t\t\"friends\":[{\"id\":\"rajeshsv\", \"type\":\"user\"},{\"id\":\"rameshr\", \"type\":\"user\"}],\n\t\t\t\"previousAddresses\":[{\"firstLine\":\"\", \"postcode\":\"\"}, {\"firstLine\":\"\", \"postcode\":\"\"}]\n\t\t}\n}"
    val jsonDB = Json.parse(sampleJson)
    println(FancyTreeProcessor.transformToPresentableJsNodes(jsonDB).mkString("[",",","]"))
  }
}
