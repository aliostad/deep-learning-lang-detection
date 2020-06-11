package client.importer
import definition.data.InstanceData
import client.comm.ClientQueryManager
import definition.data.{Reference,OwnerReference}
import util.ExportContainer
import definition.expression.{StringParser,StringConstant,Expression}
import definition.expression.ParserError
import definition.typ.{AllClasses,DataType,AbstractObjectClass}

class ConvertRule(val oldClassID:Int,val newClassID:Int,val newFields:Seq[(Int,Int)],val childPropFields:Map[Int,Int]) {
  
  def this(data:InstanceData)= {    
    this(data.fieldValue.head.toInt,data.fieldValue(1).toInt,
        for (inst <- ClientQueryManager.queryInstance(data.ref, 0))
        yield inst.fieldValue.head.toInt -> inst.fieldValue(1).toInt ,
         (for(inst <-ClientQueryManager.queryInstance(data.ref, 1)) 
        	yield inst.fieldValue.head.toInt -> inst.fieldValue(1).toInt).toMap)
  }
  
  
}

object OldDBConvertSettings {
  lazy val convertRuleInsts=definition.typ.SystemSettings().getCustomSettings("OldDBImport")
  
  lazy val convertRules= collection.mutable.HashMap[Int,Option[ConvertRule]]()
  
  //def hasRule(oldClassID:Int)=convertRuleInsts.exists(_.fieldValue(0).toInt==oldClassID)
  
  def getRule(oldClassID:Int)= convertRules.getOrElseUpdate(oldClassID,
      convertRuleInsts.find(_.fieldValue.head.toInt==oldClassID).map(new ConvertRule(_)))
    
  /** checks if it's possible to import an oldDB instance to the given prop field
   * 
   */
  def canImport(oldClassID:Int,parentClass:AbstractObjectClass,npropField:Byte,targetIsEmpty:Boolean):Boolean= {
    getRule(oldClassID) match {
      case Some(convData)=>
        //println("convData: newClass"+convData.newClassID+" newFields:"+convData.newFields.mkString(",")+" propField:"+npropField+" isEmpty:"+targetIsEmpty)
		    val propField=parentClass.propFields(npropField)
        if(propField.single&& !targetIsEmpty) return false
        if(propField.allowedClass>0) AllClasses.get.getClassByID(convData.newClassID).inheritsFrom(propField.allowedClass)
else true
      case None=> false
    }
  }
  
  def importData(oldData:ExportContainer,newParent:OwnerReference,parentClass:AbstractObjectClass):Unit= {
    getRule(oldData.classID) match {
      case Some(convData)=>
        val propField=parentClass.propFields(newParent.ownerField)
        val theClass=AllClasses.get.getClassByID(convData.newClassID)
        if(propField.allowedClass>0 && !theClass.inheritsFrom(propField.allowedClass)) return
        val instID=ClientQueryManager.createInstance(convData.newClassID, Array(newParent))
        val ref=new Reference(convData.newClassID,instID)
        for((oldField,newField)<-convData.newFields){
          val oldText=oldData.fields(oldField).replace("÷","/")
          if(oldText.length>0)
            ClientQueryManager.writeInstanceField(ref, newField.toByte,
                StringParser.parse(oldText,theClass.fields(newField).typ)match {
                	case p:ParserError=> //println("in Feld "+theClass.fields(newField).name+
                	//val fieldTyp=theClass.fields(newField).typ
                	/*if(fieldTyp==DataType.StringTyp)*/ new StringConstant(oldText) /*else Expression.generateNullConstant(fieldTyp)*/
                	case e:Expression=> e
              })
        }
        val propRefMap=collection.mutable.HashMap[Int,OwnerReference]()
        for(childData<-oldData.children)
          convData.childPropFields.get(childData.classID) match {
          case Some(prField)=> importData(childData,propRefMap.getOrElseUpdate(prField,new OwnerReference(prField.toByte,ref)),theClass)
          case None =>
        }
      case None =>
    }
  }
  
}