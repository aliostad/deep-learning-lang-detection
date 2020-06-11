

package base

import org.scalatest._
import drivedog.Google
import scala.collection.JavaConversions._
import com.google.api.services.drive.model.File
import com.google.api.services.drive.model.ParentReference
import com.google.api.client.util.DateTime

class BaseTest extends FlatSpec {
   def createFile(name:String,modified:String):File = {
    val helloWorldOldFile = new File
    helloWorldOldFile.setTitle(name)
    helloWorldOldFile.setMimeType(Google.FILE)
    val parent = new ParentReference()
    parent.setId(dir.getId)
    
    helloWorldOldFile.setParents(  List( parent).toList)
    

    helloWorldOldFile.setModifiedDate(new DateTime(modified))
    val r = Google.service.files().insert(helloWorldOldFile).execute
    r
  }
  
  val GoogleUnitTestDirectory = "drivedogunittest"
  val LocalUnitTestDirectory = "/tmp/unittestgdrive/"
  println("setup")
  Google.ROOT = LocalUnitTestDirectory
  
  new java.io.File(LocalUnitTestDirectory).renameTo(new java.io.File(LocalUnitTestDirectory.replaceAll("/$", "")+"."+System.currentTimeMillis()))
  new java.io.File(LocalUnitTestDirectory).mkdirs()
  
  val unittest = Google.service.files().list().setQ("title = '"+GoogleUnitTestDirectory+"'")

  for(f <- unittest.execute.getItems ) {
    println("############### Delete unittest directories ",f.getTitle,f.getId)
    Google.service.files().delete(f.getId).execute()
  }
  
  def deleteMarkerFile(parentId:String) = {
    val myHostName = Google.getLocalHostNameForDriveDog
    
    for(f <- Google.service.files().list().setQ("'"+parentId +"' in parents and title = '"+myHostName+"'"   ).execute.getItems ) {
      println("***************** Delete marker file",parentId,f.getTitle,f.getId)
      Google.service.files().delete(f.getId).execute()
      
    }
  }
  
  val unittestDirectory = new File
  
  unittestDirectory.setTitle(GoogleUnitTestDirectory)
  unittestDirectory.setMimeType(Google.FOLDER)
  val dir = Google.service.files().insert(unittestDirectory).execute()
  //val dir = unittest.execute.getItems.get(0)
  
  val helloWorldOldFile = createFile("helloworldOld.txt","1980-01-31T00:00:00.000")
 
  
  println("setup complete")

}