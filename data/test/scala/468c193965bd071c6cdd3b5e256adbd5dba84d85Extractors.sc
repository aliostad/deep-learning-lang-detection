class Person(val name:String, val age:Int) {
  def asTuple() : (String,Int) = (name,age)
}

object Person {
  def apply(name:String,age:Int) = new Person(name,age)
  def unapply(p:Person) : Option[(String,Int)] = Some((p.name,p.age))
}

object OldEnough {
  def unapply(p:Person) : Boolean = p.age > 39
}

val persons = List( Person("Hendrik",40), Person("Martin",35), Person("Karl",45) )

// simple casse using the unapply of the person object
persons(1) match {
  case Person(name,age) => println(name+" is "+age+" years old")
}

// collect with case anonymous function
persons.collect{case Person(name,age) => println(name+" is "+age+" years old! ")}

// Boolean extractor
persons.collect{case person @ OldEnough()  => println(person.name+" is old enough! ")}

// Extracting a stream
val xs = "A" #:: "B" #:: "C" #:: Stream.empty
xs match {
  case one #:: two #:: _ => println(one,two)
  case _ => "Nil"
}
xs match {
  case  #::(one,#::(two,_))=> println(one,two)
  case _ => "Nil"
}
xs match {
  case Stream(a,b,c,d) => println(a,b,c,d)
  case Stream(a,b,c) => println(a,b,c)
  case Stream(a,b,_*) => println(a,b)
}

// Sequence extractor
object AgeDigits {
  def unapplySeq(age:Int): Option[Seq[Int]] = {
    // This is for simplicity although it fails if the last digit is a zero
    def iter (age:Int) : List[Int] = if (age>0) age % 10 :: iter(age/10) else Nil
    Some(iter(age).reverse)
  }
}

val p = Person("Yoda",3485)
p.age match {
  case AgeDigits(d,_*) => p.name + " is " + d + " thousand years old!"
}

// Value definitions via pattern extraction
val Person(name,_) = persons(0)
println("Just the name: "+name)

def allTheNames = for {
  p <- persons
  (name,age) = p.asTuple
  if (age > 39) } yield name

allTheNames.foreach( x => println(x))

