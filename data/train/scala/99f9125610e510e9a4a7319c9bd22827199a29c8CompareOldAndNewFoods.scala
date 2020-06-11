/*
This file is part of Intake24.

Copyright 2015, 2016 Newcastle University.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package uk.ac.ncl.openlab.intake24.foodxml.scripts


import scala.xml.XML

object CompareOldAndNewFoods {
  def main(args: Array[String]) = {
   /* val oldFoods = FoodDef.parseXml(XML.load("D:\\SCRAN24\\Data\\foods-old.xml"))
    val newFoods = FoodDef.parseXml(XML.load("D:\\SCRAN24\\Data\\foods-new.xml"))
    
    val added = newFoods.filterNot(nf => oldFoods.exists(_.code == nf.code))
    val removed = oldFoods.filterNot(nf => newFoods.exists(_.code == nf.code)) 
    
    println (s"${added.size} foods added:")
    added.foreach ( f => println (f.code + "\t" + f.description) )
     
    println (s"${removed.size} foods deleted:")
    removed.foreach ( f => println (f.code + "\t" + f.description) )
    
    val newFoodsWithPortionSizes = newFoods.map ( f => oldFoods.find(_.code == f.code) match {
      case Some(of) => f.copy ( portionSize = of.portionSize)
      case None => f
    })
    
    Util.writeXml(FoodDef.toXml(newFoodsWithPortionSizes), "D:\\SCRAN24\\Data\\foods-new-ps.xml")
   */ 
  }
}