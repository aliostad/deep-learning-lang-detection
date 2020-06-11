package harvesting.crosswalks.periods

import java.io.FileInputStream
import java.util.zip.GZIPInputStream
import org.scalatestplus.play._
import play.api.test._
import play.api.test.Helpers._

class PeriodODefinitionSpec extends PlaySpec {
  
  private val DUMP_FILE = "test/resources/harvesting/crosswalks/periods/periodo-20170620.json.gz"
  
  "Parsing the PeriodO definition file" should {
    
    "return a list of definition objects" in {
      val stream = new GZIPInputStream(new FileInputStream(DUMP_FILE))   
      val definitions = PeriodoCrosswalk.parseDefinitionsDump(stream)
      definitions.size mustBe 4630
    }
    
  }
  
}