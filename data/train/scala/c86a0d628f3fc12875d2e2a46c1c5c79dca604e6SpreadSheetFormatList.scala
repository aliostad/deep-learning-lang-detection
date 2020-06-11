package client.spreadsheet
import definition.data.Reference
import client.comm.ClientQueryManager
import definition.comm.NotificationType
import definition.data.InstanceData
import definition.expression.IntConstant
import scala.swing.Swing

class SpreadSheetFormatList(controller:SpreadSheetController) {
  private var list:List[SpreadSheetFormatRange]= List(SpreadSheet.defaultFormat)
  var subsID:Int= -1
  
  def load(spreadSheetRef:Reference)= {
    shutDown()
    subsID==ClientQueryManager.createSubscription(controller.spreadSheetRef,3)((command,data)=> Swing.onEDT{
    	command match {
    		case NotificationType.sendData|NotificationType.updateUndo =>
          updateData(data)
          controller.refresh()
          if(command == NotificationType.sendData) controller.loadDoneListener()
        case NotificationType.fieldChanged =>
          val format=new SpreadSheetFormatRange(data.head)
          list=list.map(entry=>if(entry.ref==format.ref) format else entry)
          controller.refresh()
        case NotificationType.childAdded =>
          val d=data.head
          val format=new SpreadSheetFormatRange(d)
          list=format ::list
          controller.refresh()
        case NotificationType.instanceRemoved =>
          list=removeElement(data.head.ref)
          controller.refresh()
      }
    })
  }
  
  def removeElement(ref:Reference):List[SpreadSheetFormatRange]= {
    val(head,tail)=list.span(_.ref!=ref)
    head::: tail.drop(1)
  }
  
  
  def updateData(data:IndexedSeq[InstanceData]) = {
    list=List(SpreadSheet.defaultFormat)
    for(d<-data)       
      list = new SpreadSheetFormatRange(d) :: list   
  }
  
  
  def filterFittingFormats(col:Int,row:Int)=list.filter(_.range.isDefinedAt(col,row))
  
  
  def getCommonFormatForRange(range:SpreadSheetRange):SpreadSheetFormat = {    
    var formatSet:IndexedSeq[Option[SpreadSheetFormat]]=IndexedSeq.empty.padTo(SpreadSheetFormat.getFormatCount,None)
    
    for (form<-list.reverse) {
      if(form.range.fillsRange(range)) formatSet=form.format.setDefinedFormats(formatSet) 
      else if(form.range.touchesRange(range)) formatSet=form.format.clearDefinedFormats(formatSet)
    }
    if(formatSet.exists(_ !=None)) new SpreadSheetFormat(formatSet)
    else UndefinedFormat
  }
  
  def getCommonFormatForCell(col:Int,row:Int):SpreadSheetFormat= {
    var formatSet:IndexedSeq[Option[SpreadSheetFormat]]=IndexedSeq.empty.padTo(SpreadSheetFormat.getFormatCount,None)
    for(form<-list.reverse) if (form.range.isDefinedAt(col,row)) formatSet=form.format.setDefinedFormats(formatSet)
    if(formatSet.exists(_ !=None)) new SpreadSheetFormat(formatSet)
    else UndefinedFormat
  }
  
  
  def shutDown()= if(subsID > -1) {
    ClientQueryManager.removeSubscription(subsID)
    subsID= -1
  }
  
  
  def setFormatValue(newRange:SpreadSheetRange,fieldNr:Int,newValue:SpreadSheetFormat):Unit= {
    //println("setFormatValue range:"+newRange+"field:"+fieldNr+"\n newValue:"+newValue)
    var untouched=true
    var extended=false
    for (oldFormat <-list) 
      if(newRange.touchesRange(oldFormat.range)&& oldFormat.format.isFormatSet(fieldNr)){
        
        if(newRange.fillsRange(oldFormat.range)) {
          if(newRange==oldFormat.range&& ! extended&& untouched) {
            // change old formatfield
            oldFormat.changeField(fieldNr,newValue)
            //println("change old FormatField "+oldFormat)
            extended=true
            untouched=false
          } else {
            oldFormat.clearField(fieldNr)
            //println("delete field in old format "+oldFormat)
            // delete field in old format and save record
            // if then no field is set anymore, delete old format record
          }
        } else untouched=false
        
      } else if(untouched && newRange==oldFormat.range) { // same range, but different fields set
        // set new Field in old Format
        oldFormat.changeField(fieldNr,newValue)
        //println("set new Field in old Format "+ oldFormat )
        extended=true
      }
    if(!extended) {
      // add new format record 
      SpreadSheetFormat.createFormat(newRange,newValue,controller)
      //println("add new Format record")
    }
  }
  
  
}