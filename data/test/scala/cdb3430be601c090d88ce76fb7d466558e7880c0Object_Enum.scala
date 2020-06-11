/**
 * Object@ ogtagorcvum e vorpisi stananq singlton object
 * kareli e unenal object ev class nuyn anunov vortex objecti mijocov kareli e 
 * stanal static funkcianeri nman irakanacumner
 * Object@ karelie jarangel, constructor parametrerov chuni,
 * sovorakan constructor@ kancvhvum e erb nran arajin angam dimum en, applay method uni
 * nuyn anunov class ev object karoxen dimel mimyanc privatnerin
 * Scalayum enum ner unenalu hamar petq e jarangvel Enumeration classic
 **/

class test_1 {
	def f = test_1.N
}

object test_1 {
	private val N = 99; //private[this] -i depqum classic chenq tesni N in
	def whoim = "I am static"
}

object test_2 extends Enumeration {
	val red, green, blue = Value // aystex yuraqanchyur arjeq inicilizacvum en Value methodi kanchov
	val name1 = Value("Bob")
	val name2 = Value("John")
	val old = Value(11)
}

object Object {
	def main(arg: Array[String]) = {
		println(test_1.whoim); //test_1.whoim static methodi efect
		val l =  new test_1()
		println(l.f)

		println(test_2.red)
		println(test_2.green)
		println(test_2.blue)
		println(test_2.name1)
		println(test_2.name2)
		println(test_2.name2.id)
		println(test_2.old) // old
		println(test_2.old.id) //11
		println(test_2(1))// green
	}
}
