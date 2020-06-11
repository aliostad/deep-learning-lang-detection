package showmyns
import scala.sys.process._
import scala.xml.XML
import Actions._
object Utils {
  
  def isVBoxEnabled = exitCode("VBoxManage --version") == 0
  
  def getVBoxVms = "VBoxManage list vms" !!
  
  def getVBoxInterfaces = {
    val peerIdxStr = (Seq("") #| Seq("","")) !! (ProcessLogger(line => ()))
    val xmlfile = XML.loadFile("/home/giuliano/VirtualBox VMs/ubuntu12.04_1/ubuntu12.04_1.vbox")
    val xml=(xmlfile \ "Machine" \ "Hardware" \  "Network" \ "Adapter" \\  "BridgedInterface")
    xml.map(_.attribute("name").get)
  } 
}