package no.antares.dbunit.converters

/* ConditionalCamelNameConverter.scala
   Copyright 2011 Tommy Skodje (http://www.antares.no)

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
/** @author Tommy Skodje */
class ConditionalCamelNameConverter( private val nextInChain: DefaultNameConverter ) extends CamelNameConverter( nextInChain ) {

  def this() = this( new DefaultNameConverter() );

  override def tableName( oldName: String ): String  = {
    if ( isCamelCased( oldName ) )
      super.tableName( oldName )
    else
      oldName
  }
  override def columnName( oldName: String ): String  = {
    if ( isCamelCased( oldName ) )
      super.columnName( oldName )
    else
      oldName
  }

  private def isCamelCased( name: String ): Boolean = {
    val chars = name.toArray[Char]
    var prevLower  = chars(0).isLower
    var allSameCase  = true
    for ( c <- chars ) {
      if ( '_' == c )
        return false;
      if ( c.isLetter )
        allSameCase  = ( allSameCase.&&( prevLower == c.isLower ) )
    }
    ! allSameCase
  }

}