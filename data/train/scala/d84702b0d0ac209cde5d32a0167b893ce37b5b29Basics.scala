object Basics{
  def main(args: Array[String]) {
    
    // Arrays
    // - arrays are mutable
    val array = new Array[String](3);
    array(0) = "This";
    array(1) = "is";
    array(2) = "mutable";
    
    array.foreach(println);
    
    // Lists
    // - lists are immutable
    val oldList = List(1,2);
    
    val newList = 3 :: oldList; // adds to beginning of List
    newList.foreach { x => println(x) };
    
    val otherList = oldList :+ 3; // adds at end of List
    otherList.foreach { x => println(x) };
    
    val afterDelete = otherList.filterNot { x => x == 2 }; // used for deleting elements from List
    afterDelete.foreach { x => println(x) };
    
    // for-loop demo
    // Imperative-form
    val files = new java.io.File(".").listFiles();
    for (file <- files) {
      val filename = file.getName;
      if (filename.endsWith(".scala")) println(filename);
    }
    // Functional-form
    val forList = for (a <- oldList; b <- otherList) yield a + b;
    println(forList.mkString(","));
  }
}