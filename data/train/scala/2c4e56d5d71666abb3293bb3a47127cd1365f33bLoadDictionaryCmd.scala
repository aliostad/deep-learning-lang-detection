/* date:   Nov 20, 2013
						LOAD DICTIONARY CMD   
*/
package com.server

case class LoadDictionaryCmd(parameters:List[String]) extends Node with Link  with Common {
	override def toString="LoadDictionaryCmd"

	val loadDictionaryParent= new NodeParent   // parent of LoadAssignCmd children

	def showPost { println("LoadDictionaryCmd: id="+id+"   next="+idNextSibling)}	

	def postIds {
		postNextSibling
		postChild
		}
	def postNextSibling {
			if(getNext !=None) {
				idNextSibling=getNext.get.getId
				}
		}
			// 'CommandStructure' iterates 'cmdVector' to invoked 'postIds' in
			// all 'xxxCmd' instances. LoadDictionaryCmd is  a child
			// of Notecard and a parent of LoadAssignCmd
	def postChild {
		if(loadDictionaryParent.getFirstChild != None) {
			idChild=loadDictionaryParent.getFirstChild.get.getId   //see Link
			}
		}
			// 'parameters' were assigned when object was instantiated
			//  by 'CommandLoader'. These parameters are loaded by 
			//  CommandToFile (following CommandStructure)
	def loadStruct( struct:scala.collection.mutable.ArrayBuffer[String]) {
			loadParametersWithParent(struct, parameters)
			}
			// LoadAssignCmd is child of LoadDictionaryCmd
	def attachSpecial(loadAssign: LoadAssignCmd)  {
			append(loadDictionaryParent, loadAssign)
			}
}
