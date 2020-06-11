44 match {
  case 44 => true
  case _ => false
}

"David" match {
  case "David" => 45
  case "Elwood" => 77
  case _ => 0
}

import _

Stuff("David", 45) match {
  case Stuff("David", 45) => true
  case _ => false
}

Stuff("David", 45) match {
  case Stuff("David", _) => "David"
  case _ => "Other"
}

Stuff("David", 45) match {
  case Stuff("David", howOld) => "David, age: "+howOld
  case _ => "Other"
}

Stuff("David", 45) match {
  case Stuff("David", age) if age < 30 => "young David"
  case Stuff("David", _) => "old David"
  case _ => "Other"
}

val x = "Hoge"
x match {
  case d: java.util.Date => "The date in milliseconds is "+d.getTime
  case u: java.net.URL => "The URL path: "+u.getPath
  case s: String => "String: "+s
  case _ => "Something else"
}

