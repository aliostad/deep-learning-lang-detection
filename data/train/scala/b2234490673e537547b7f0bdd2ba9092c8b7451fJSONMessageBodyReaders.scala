/* Copyright 2013 Advanced Media Workflow Association and European Broadcasting Union

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License. */

package tv.amwa.ebu.fims.rest.rest.message
import scala.xml.NodeSeq
import javax.ws.rs.ext.MessageBodyReader
import java.lang.reflect.Type
import java.lang.annotation.Annotation
import javax.ws.rs.core.MediaType
import javax.ws.rs.core.MultivaluedMap
import java.io.InputStream
import tv.amwa.ebu.fims.rest.converter.FimsJSON
import tv.amwa.ebu.fims.rest.model.capture.CaptureJobType
import javax.ws.rs.Consumes
import javax.ws.rs.ext.Provider
import tv.amwa.ebu.fims.rest.converter.Reader
import tv.amwa.ebu.fims.rest.Constants
import tv.amwa.ebu.fims.rest.converter.XMLConverters._
import tv.amwa.ebu.fims.rest.model.ManageJobRequestType
import tv.amwa.ebu.fims.rest.model.ManageQueueRequestType
import tv.amwa.ebu.fims.rest.model.BMContentType

abstract class GenericJSONMessageBodyReader[T](implicit val manifest: Manifest[T], implicit val xmlReader: Reader[T,NodeSeq]) extends MessageBodyReader[T] {
  def isReadable(aClass : Class[_], genericType : Type, annotations : Array[Annotation], mediaType : MediaType) = manifest.runtimeClass.isAssignableFrom(aClass)
  def readFrom(aClass : Class[T], genericType : Type, annotations : Array[Annotation], mediaType : MediaType, 
      httpHeaders : MultivaluedMap[String, String], entityStream : InputStream) : T = {
	FimsJSON.fromStream[T](entityStream, Constants.DEFAULT_XML_ENCODING)
  }  
}

@Provider
@Consumes(Array(MediaType.APPLICATION_JSON))
object JobJSONMessageBodyReader extends GenericJSONMessageBodyReader[CaptureJobType]

@Provider
@Consumes(Array(MediaType.APPLICATION_JSON))
object ManageJobJSONMessageBodyReader extends GenericJSONMessageBodyReader[ManageJobRequestType]

@Provider
@Consumes(Array(MediaType.APPLICATION_JSON))
object ManageQueueJSONMessageBodyReader extends GenericJSONMessageBodyReader[ManageQueueRequestType]

@Provider
@Consumes(Array(MediaType.APPLICATION_JSON))
object BMContentJSONMessageBodyReader extends GenericJSONMessageBodyReader[BMContentType]