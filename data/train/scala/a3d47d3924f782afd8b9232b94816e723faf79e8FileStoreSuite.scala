import org.scalatest.FunSuite
import java.util.Date

class DateProvider(date:()=>Date){
  def apply() = date()
}
object DateProvider{
  def apply(date:()=> Date) = new DateProvider(date)
}

class FileStore(implicit val date:DateProvider = DateProvider {() => new Date}){
  val keyseq = collection.mutable.ListBuffer[String]()
  val innerMap = collection.mutable.Map[String, (String, Option[Long])]()

  def set(key: String, value :String, ttl: Long = -1){
    key match {
      case "" => 
      case null => 
      case _ => {
	keyseq -= key
	keyseq += key
	val retValue = if(value =="${now}"){
	  "%1$tY-%1$tm-%1$td %1$tk:%1$tM:%1$tS".format(date())
	}else value
	val delTime = if(ttl < 0) None
		      else Some(date().getTime + ttl)
	innerMap(key) = (retValue, delTime)
      }
    }
  }

  def get(key: String):Option[String] = innerMap.get(key) match {
    case Some((value, None)) => Some(value)
    case Some((value, Some(ttl))) if ttl > date().getTime => Some(value)
    case _ => None
  }

  def dump():String = ("" /: keyseq) {
    (str, key) => str + "%s:%s\n".format(key, innerMap(key)._1)
  }

  def setMulti(a:(String, String)*){
    for((key, value) <- a){
      set(key, value)
    }
  }

  def getMulti(a:String*)={
    (for(key <- a; value <- get(key)) yield value).toList
  }
}

class FileStoreSuite extends FunSuite{
  var timeDuringTest = new Date(1278747080877L)
  implicit val testDate = DateProvider {() => timeDuringTest}


  test("""set "A"->"123" and get("A") is "123" getTest""") {
    val fs = new FileStore
    fs.set("A", "123")
    assert (fs.get("A") === Some("123"))
  }

  test("""set "B"->"456" and get("B") is "456" getTest""") {
    val fs = new FileStore
    fs.set("B", "456")
    assert (fs.get("B") === Some("456"))
  }

  test("""set empty string as key Test""") {
    val fs = new FileStore
    fs.set("", "ABCDEF")
    assert (fs.get("") === None)
  }

  test("""set empty string as value Test""") {
    val fs = new FileStore
    fs.set("ABC", "")
    assert (fs.get("ABC") === Some(""))
  }

  test("""set null as key Test""") {
    val fs = new FileStore
    fs.set(null, "")
    assert (fs.get(null) === None)
  }

  test("""dump empty Test""") {
    val fs = new FileStore
    assert (fs.dump === "")
  }

  test("""dump a value Test""") {
    val fs = new FileStore
    fs.set("ABC", "123")
    assert (fs.dump === "ABC:123\n")
  }

  test("""dump 2 value Test""") {
    val fs = new FileStore
    fs.set("ABC", "123")
    fs.set("DEF", "456")
    assert (fs.dump === "ABC:123\nDEF:456\n")
  }

  test("""dump 3 value Test""") {
    val fs = new FileStore
    fs.set("ABC", "123")
    fs.set("DEF", "456")
    fs.set("GHI", "789")
    assert (fs.dump === "ABC:123\nDEF:456\nGHI:789\n")
  }


  test("""dump 2 value and empty Test""") {
    val fs = new FileStore
    fs.set("ABC", "123")
    fs.set("", "456")
    fs.set("GHI", "789")
    assert (fs.dump === "ABC:123\nGHI:789\n")
  }

  test("""unknown key Test""") {
    val fs = new FileStore
    assert (fs.get("ABC") === None)
  }

  test("""update key Test""") {
    val fs = new FileStore
    fs.set("ABC", "123")
    fs.set("ABC", "456")
    assert (fs.get("ABC") === Some("456"))
  }

  test("""Sceanario Test1"""){
    val s = new FileStore

    s.set("foo", "hoge")
    assert(s.get("foo") === Some("hoge"))
    assert(s.dump === "foo:hoge\n")
    
    s.set("bar", "fuga")
    assert(s.dump === "foo:hoge\nbar:fuga\n")
    
    assert(s.get("toto") === None)
    
    s.set(null, "momo")
    s.set("", "gogo")
    assert(s.dump === "foo:hoge\nbar:fuga\n")

    s.set("foo", "piyo")
    assert(s.dump === "bar:fuga\nfoo:piyo\n")
  }
  test("""multi get/set Test"""){
    val fs = new FileStore
    fs.setMulti(("foo", "hoge"), ("bar", "fuga"))
    assert(fs.getMulti("foo", "bar") === List("hoge", "fuga"))
    fs.setMulti(("foo", "hoge2"), ("bar", "fuga"))
    assert(fs.getMulti("foo", "bar") === List("hoge2", "fuga"))
    assert(fs.getMulti("zoo", "bar") === List("fuga"))
  }

  test("""$now Test"""){
    val fs = new FileStore
    fs.set("foo", "${now}")
    assert(fs.get("foo") === Some("2010-07-10 16:31:20"))
  }

  test(""" Time to live Test"""){
    val fs = new FileStore
    fs.set("foo", "bar", 1)
    assert(fs.get("foo") === Some("bar"))
    timeDuringTest = new Date(1278747080877L+1001L)
    assert(fs.get("foo") === None)
  }    
}
