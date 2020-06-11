package uk.co.randomcoding.drinkfinder.model.datatemplate

/**
 * Object to manage data templates for upload of spreadsheet data.
 */
object DataTemplates {

	/**
	 * The map of template names to the files that contain the template to use
	 * when loading the spreadsheet source
	 */
	val templatesMap : Map[String, String] = {
		import scala.io.Source
		val templatesSource = Source.fromInputStream(DataTemplates.getClass().getResourceAsStream("/templates.properties"))

		val templateLines = for {
			line <- templatesSource.getLines
			if line.trim().nonEmpty
			if !line.startsWith("#")
		} yield {
			val parts = line.split("=")
			(parts(1), parts(0))
		}
		
		templateLines.toMap
	}
}