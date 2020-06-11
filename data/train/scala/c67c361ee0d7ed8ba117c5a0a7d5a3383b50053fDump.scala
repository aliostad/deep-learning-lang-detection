import EasyJson.{EasyJson, JsonData, ParseError}
import org.scalatest._

class DumpTest extends FlatSpec {
    "EasyJson" should "be able to dump an empty list" in {
        assert(EasyJson.dumps(JsonData(Vector[Any]())) == "[]")
    }
    it should "be able to dump an empty object" in {
        assert(EasyJson.dumps(JsonData(Map[String,Any]())) == "{}")
    }
    it should "be able to dump a list of integers" in {
        assert(EasyJson.dumps(JsonData(Vector(0,1,1,2,3,5))) == "[0,1,1,2,3,5]")
    }
    it should "be able to dump a list of floats" in {
        assert(EasyJson.dumps(JsonData(Vector(1.02, 3.14))) == "[1.02,3.14]")
    }
    it should "be able to dump a mixed list" in {
        assert(EasyJson.dumps(JsonData(Vector("a", 42, 3.14))) == "[\"a\",42,3.14]")
    }
    it should "be able to dump an empty string" in {
        assert(EasyJson.dumps(JsonData("")) == "\"\"")
    }
    it should "be able to dump zero (integer)" in {
        assert(EasyJson.dumps(JsonData(0)) == "0")
    }
    it should "be able to dump zero (float)" in {
        assert(EasyJson.dumps(JsonData(0.0)) == "0.0")
    }
    it should "be able to dump a list with one integer" in {
        assert(EasyJson.dumps(JsonData(Vector(1234))) == "[1234]")
    }
    it should "be able to dump a list with a single key" in {
        assert(EasyJson.dumps(JsonData(Map("a" -> 1234))) == "{\"a\":1234}")
    }
}

class LoadAndDumpTest extends FlatSpec {
    "EasyJson" should "be able to load and dump an empty list" in {
        assert(EasyJson.dumps(EasyJson.loads("[]")) == "[]")
    }
    it should "be able to load and dump an empty object" in {
        assert(EasyJson.dumps(EasyJson.loads("{}")) == "{}")
    }
    it should "be able to load and dump an empty string" in {
        assert(EasyJson.dumps(EasyJson.loads("\"\"", true)) == "\"\"")
    }
    it should "be able to load and dump zero (integer)" in {
        assert(EasyJson.dumps(EasyJson.loads("0", true)) == "0")
    }
    it should "be able to load and dump zero (float)" in {
        assert(EasyJson.dumps(EasyJson.loads("0.0", true)) == "0.0")
    }
    it should "be able to load and dump a list with one integer" in {
        assert(EasyJson.dumps(EasyJson.loads("[1234]")) == "[1234]")
    }
    it should "be able to load and dump a list with a single key" in {
        assert(EasyJson.dumps(EasyJson.loads("{\"a\":1234}")) == "{\"a\":1234}")
    }
}
