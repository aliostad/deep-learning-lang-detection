import org.scalamock.scalatest.MockFactory
import org.scalatest.FlatSpec

class StuffTest extends FlatSpec with MockFactory {

  "A stuff" should "write stuff to db" in {
    val dbmock = mock[Database]
    Stuff.setDatabase(dbmock)
    (dbmock.write _).expects("A", "string").once()
    (dbmock.close _).expects().once()
    Stuff.writeAtoDB()
  }

  "A stuff" should "write B stuff to db" in {
    val dbmock = mock[Database]
    Stuff.setDatabase(dbmock)
    (dbmock.write _).expects("B", "string").twice()
    (dbmock.close _).expects().twice()
    Stuff.writeBtoDB()
  }
}
