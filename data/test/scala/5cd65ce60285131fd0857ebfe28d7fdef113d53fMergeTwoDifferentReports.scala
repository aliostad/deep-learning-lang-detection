package planet7.tabular.recipes

import java.io.File

import org.scalatest.{MustMatchers, WordSpec}
import planet7.Diff

class MergeTwoDifferentReports extends WordSpec with MustMatchers {

  import planet7.tabular._

  val postcodeLookupTable = Csv(new File("src/test/resources/planet7/tabular/before/postcodes.csv")).iterator.map {
    case Row(Array(oldCode, newCode), _) => oldCode -> newCode
  }.toMap

  val expectedOutput = new File("src/test/resources/planet7/tabular/after/after.csv")
  val modelAnswer = Csv(expectedOutput).columnStructure(ignore("Email"))
  val differ = RowDiffer(modelAnswer.header, "Company ID")

  "Convert different formats into a canonical format, and merge" in {
    import planet7.tabular._

    val oldFormat = new File("src/test/resources/planet7/tabular/before/old_company_format.csv")
    val newFormat = new File("src/test/resources/planet7/tabular/after/new_company_format.csv")

    val oldFormatRemastered = Csv(oldFormat)
      .columnStructure("Company", "Company account" -> "Company ID", "First name", "Surname", "Postcode" -> "Zip code")
      .withMappings("Zip code" -> postcodeLookupTable)

    val newFormatClipped = Csv(newFormat)
      .columnStructure(ignore("Email"))                         // Ignore columns

    val combined = Csv(oldFormatRemastered, newFormatClipped)   // Merge CSVs

    Diff(combined, modelAnswer, differ) mustEqual Nil           // Diff for assertions
  }
}