import org.specs2.mutable._

import play.api.test._
import play.api.test.Helpers._
import play.api.libs.json._

import controllers.OldLog
import models.OldRakeProperties

class FunctionSpec extends Specification {
  OldRakeProperties.setProperty("encModulus", "7577257274191551097624277939619648834415258346195701624702241427507596352378240942764032510385901727639861216319309817735955405453593241345706416751624437")
  OldRakeProperties.setProperty("encPubExponent", "65537")

  "Encryption" should {
    "Number, no body field" in new WithApplication {
      val json = Json.parse(
        "{\n" +
          "            \"properties\": {\n" +
          "                \"localTime\": \"20140428170643946\",\n" +
          "                \"header\": 3,\n" +
          "                \"_$body\": {\n" +
          "                }\n" +
          "            },\n" +
          "            \"_$encryptionFields\": [\n" +
          "                \"localTime\",\n" +
          "                \"header\"\n" +
          "            ]\n" +
          "        }")
      OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY \ "_$body")(OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY)(json)) mustEqual Json.parse(
        "{" +
          "\"properties\": {" +
          "\"localTime\": \"g5kUSFp6ZURfGaQnFTudEDdOu79W9uHntn6MTcK7xzA2eRYNlemfUTPjtuUgmINJ023VnBULEEoQBu2lHByHLg==\"," +
          "\"header\": \"iTlo1R/t9IYR7xQTIwA1hB4niG1ZnCiFhWeD91Imca0wiPI0IFJW90HUq8k2+Nc/8i1gSnDQ1KUA0zR9NJ+Y1A==\"," +
          "\"_$body\": {}" +
          "}," +
          "\"_$encryptionFields\": [" +
          "\"localTime\", " +
          "\"header\"" +
          "]}")
    }

    "Normal, body" in new WithApplication {
      val json = Json.parse(
        "{\n" +
          "            \"properties\": {\n" +
          "                \"localTime\": \"20140428170643946\",\n" +
          "                \"header\": 3,\n" +
          "                \"_$body\": {\n" +
          "                     \"body1\" : \"my body\"\n" +
          "                }\n" +
          "            },\n" +
          "            \"_$encryptionFields\": [\n" +
          "                \"localTime\",\n" +
          "                \"header\"\n," +
          "                \"body1\"\n" +
          "            ]\n" +
          "        }")
      OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY \ "_$body")(OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY)(json)) mustEqual Json.parse(
        "{" +
          "\"properties\":{" +
          "\"localTime\": \"g5kUSFp6ZURfGaQnFTudEDdOu79W9uHntn6MTcK7xzA2eRYNlemfUTPjtuUgmINJ023VnBULEEoQBu2lHByHLg==\"," +
          "\"header\": \"iTlo1R/t9IYR7xQTIwA1hB4niG1ZnCiFhWeD91Imca0wiPI0IFJW90HUq8k2+Nc/8i1gSnDQ1KUA0zR9NJ+Y1A==\"," +
          "\"_$body\":{" +
          "\"body1\":\"To5pF380V6WLOmAthDTuvRQp/evtopnRLADZ/daBJtkgSRRLFu5BmN4OXbJiubBtA416WmYi+LduCTitCvtzOg==\"}" +
          "}," +
          "\"_$encryptionFields\": [" +
          "\"localTime\"," +
          "\"header\"," +
          "\"body1\"]}")
    }

    "No key, null value" in new WithApplication {
      val json = Json.parse(
        "{\n" +
          "            \"properties\": {\n" +
          "                \"localTime\": \"20140428170643946\",\n" +
          "                \"_$body\": {\n" +
          "                     \"body1\" : null\n" +
          "                }\n" +
          "            },\n" +
          "            \"_$encryptionFields\": [\n" +
          "                \"localTime\",\n" +
          "                \"header\"\n," +
          "                \"body1\"\n" +
          "            ]\n" +
          "        }"
      )
      OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY \ "_$body")(OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY)(json)) mustEqual Json.parse(
        "{\"properties\":" +
          "{\"localTime\":\"g5kUSFp6ZURfGaQnFTudEDdOu79W9uHntn6MTcK7xzA2eRYNlemfUTPjtuUgmINJ023VnBULEEoQBu2lHByHLg==\"," +
          "\"_$body\":{\"body1\":null}}, \"_$encryptionFields\":[\"localTime\", \"header\", \"body1\"]}")
    }

    "_$body enc, whole body" in new WithApplication {
      val json = Json.parse(
        "{\n" +
          "            \"properties\": {\n" +
          "                \"localTime\": \"20140428170643946\",\n" +
          "                \"_$body\": {\n" +
          "                     \"body1\" : null\n" +
          "                }\n" +
          "            },\n" +
          "            \"_$encryptionFields\": [\n" +
          "                \"_$body\"\n" +
          "            ]\n" +
          "        }")
      OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY \ "_$body")(OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY)(json)) mustEqual Json.parse(
        "{\"properties\":{\"localTime\":\"20140428170643946\", \"_$body\":{\"body1\":null}}, \"_$encryptionFields\":[\"_$body\"]}")
    }

    "_$body collection" in new WithApplication {
      val json = Json.parse(
        "{\n" +
          "            \"properties\": {\n" +
          "                \"localTime\": \"20140428170643946\",\n" +
          "                \"_$body\": {\n" +
          "                     \"bodylist\" : [\"a\", \"b\", \"c\"],\n" +
          "                     \"bodymap\" : {\"k1\" : \"a\", \"k2\" : \"b\", \"k3\" : \"c\"}\n" +
          "                }\n" +
          "            },\n" +
          "            \"_$encryptionFields\": [\n" +
          "                \"bodylist\", \n" +
          "                \"bodymap\"\n" +
          "            ]\n" +
          "        }")
      OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY \ "_$body")(OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY)(json)) mustEqual Json.parse(
        "{\"properties\":{\"localTime\":\"20140428170643946\", \"_$body\":{\"bodylist\":[" +
          "\"F3nJGR/ghWX9CwDTQ2DEtBcCObLwbyhfjH1+OWWw9CBrDPyp+efuk7TdcgvCX0DGCuXQkTjaqwLD0yd5Ip94ag==\"," +
          "\"QMl6dUSxLRdtVckPcrHBGpu9D4BfefDlZMtFncKYTyd09scodoBnP9F2rS3ZTjc7swObVC4jsyy+nQKbjvh1tg==\"," +
          "\"OvwlJtDb6Mki2wqjiIOOBLyEo2wOKWO3hkVM4+K9cE0uIvYZ+K/taqmKJ251YzKwKOCfjNgVBYI/yZmYlsoeGQ==\"]," +
          "\"bodymap\":{" +
          "\"k1\":\"F3nJGR/ghWX9CwDTQ2DEtBcCObLwbyhfjH1+OWWw9CBrDPyp+efuk7TdcgvCX0DGCuXQkTjaqwLD0yd5Ip94ag==\"," +
          "\"k2\":\"QMl6dUSxLRdtVckPcrHBGpu9D4BfefDlZMtFncKYTyd09scodoBnP9F2rS3ZTjc7swObVC4jsyy+nQKbjvh1tg==\"," +
          "\"k3\":\"OvwlJtDb6Mki2wqjiIOOBLyEo2wOKWO3hkVM4+K9cE0uIvYZ+K/taqmKJ251YzKwKOCfjNgVBYI/yZmYlsoeGQ==\"}}}," +
          "\"_$encryptionFields\":[\"bodylist\", \"bodymap\"]}")
    }

    "empty enc value" in new WithApplication {
      val json = Json.parse(
        "{\n" +
          "            \"properties\": {\n" +
          "                \"localTime\": \"20140428170643946\",\n" +
          "                \"_$body\": {\n" +
          "                     \"body1\" : null\n" +
          "                }\n" +
          "            },\n" +
          "            \"_$encryptionFields\": [\n" +
          "            ]\n" +
          "        }"
      )
      OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY \ "_$body")(OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY)(json)) mustEqual Json.parse(
        "{\"properties\":{\"localTime\":\"20140428170643946\", \"_$body\":{\"body1\":null}}, \"_$encryptionFields\":[]}")
    }

    "no enc key" in new WithApplication {
      val json = Json.parse(
        "{\n" +
          "            \"properties\": {\n" +
          "                \"localTime\": \"20140428170643946\",\n" +
          "                \"_$body\": {\n" +
          "                     \"body1\" : null\n" +
          "                }\n" +
          "            }\n" +
          "        }"
      )
      OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY \ "_$body")(OldLog.encrypt(__ \ OldLog.PROPERTIES_KEY)(json)) mustEqual Json.parse(
        "{\"properties\":{\"localTime\":\"20140428170643946\", \"_$body\":{\"body1\":null}}}")
    }
  }
}
