package edison.yaml

import edison.util.SmartSpec

class YamlDumperTest extends SmartSpec {
  behavior of "YamlDumper"

  def dump[T](x: T): String = ScalaYaml.dump(x).trim

  it must "dump integers" in {
    dump(123) shouldBe "123"
  }

  it must "dump doubles" in {
    dump(123.42) shouldBe "123.42"
  }

  it must "dump strings" in {
    dump("abc") shouldBe "abc"
  }

  it must "dump a list of strings and integers" in {
    dump(List(123, "abc")) shouldBe
      """
        |- 123
        |- abc
      """.strip
  }

  it must "dump a map of strings and integers" in {
    dump(Map("abc" -> 123, "def" -> 456)) shouldBe
      """
        |abc: 123
        |def: 456
      """.strip
  }

  it must "dump nested collections" in {
    val obj = Map(
      "abc" -> Map(123 -> 789),
      "def" -> List(1, "x")
    )

    dump(obj) shouldBe
      """
        |abc:
        |  123: 789
        |def:
        |- 1
        |- x
      """.strip
  }

  it must "dump sets" in {
    val obj = Set("a", "b")

    dump(obj) shouldBe
      """
        |!!set
        |a: ''
        |b: ''
      """.strip
  }

  it can "be extended to support custom case classes (map adapter)" in {
    case class Person(name: String, age: Int, emails: List[String])

    val dumper = new ScalaYamlDumper(
      new ScalaObjRepresenter {
        addCustomRepresenter({ person: Person =>
          Map(
            "name" -> person.name,
            "age" -> person.age,
            "emails" -> person.emails
          )
        })
      }, new DefaultDumperOptions
    )

    dumper.dump(List(Person("John", 35, List("abc", "def")))).trim shouldBe
      """
        |- name: John
        |  age: 35
        |  emails:
        |  - abc
        |  - def
      """.strip
  }

  it can "be extended to support custom case classes (list adapter)" in {
    case class Coordinates(x: Int, y: Int)

    val dumper = new ScalaYamlDumper(
      new ScalaObjRepresenter {
        addCustomRepresenter({ coordinates: Coordinates => List(coordinates.x, coordinates.y) })
      }, new DefaultDumperOptions
    )

    dumper.dump(Coordinates(4, 5)).trim shouldBe
      """
        |- 4
        |- 5
      """.strip
  }
}
