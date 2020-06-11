package ads.website

import org.scalatest.FunSuite
import java.util
import ads.web.WebUtils


class PersonOld (var map: java.util.HashMap[String,String])
class PersonNew (var map: Map[String,String])

class JsonSpecs extends FunSuite{
    test("list"){
        val list = List[PersonNew](new PersonNew(Map("name" -> "viet")))

        println(list.getClass)

        val s = WebUtils.toRawJson(list)
        println(s)
    }

    test("convert"){
        val map = new util.HashMap[String,String]()
        map.put("x", "1")
        map.put("y", "2")
        val old = new PersonOld(map)
        val s = WebUtils.toRawJson(old)
        val current = WebUtils.fromJson(classOf[PersonNew], s)

        for (e <- current.map){
            println(e)
        }
    }
}
