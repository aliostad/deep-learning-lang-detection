44 match {
  case 44 => true // if we match 44, the result is true
  case _ => false // otherwise the result is false
}


// pattern-Match fuer Klassen
Stuff("David", 45) match {
  case Stuff("David", 45) => true
  case _ => false
}

// koennen den Namen testen, wobei uns der zweite Parameter (age) rille ist
Stuff("David", 45) match {
  case Stuff("David", _) => "David"
  case _ => "Other"
}

// koennen das age field extrahieren und in die howold-Variable schreiben
Stuff("David", 45) match {
  case Stuff("David", howOld) => "David, age: "+howOld
  case _ => "Other"
}

// koennen einen Guard setzen
Stuff("David", 45) match {
  case Stuff("David", age) if age < 30 => "young David"
  case Stuff("David", _) => "old David"
  case _ => "Other"
}
