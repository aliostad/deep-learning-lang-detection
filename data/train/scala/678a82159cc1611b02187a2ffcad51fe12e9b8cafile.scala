import scala.io.Source
import scala.collection.mutable

object rdFile{
  def main(args:Array[String]){
    val counts = mutable.Map.empty[String,Int]
    if(args.length > 0){
      for(line <- Source.fromFile(args(0)).getLines()){
        for(wd <- line.split("[\\]\\[=+->()\"}{ \\',.]+")){
          if(wd != ""){
            val oldCount = 
              if(counts.contains(wd.toLowerCase)) counts(wd)
              else 0
            counts += (wd -> (oldCount + 1) )
          }

        }
      }
    }
    else 
      Console.err.println("Please enter filename")
  
   println(counts.toList)
  }
}
