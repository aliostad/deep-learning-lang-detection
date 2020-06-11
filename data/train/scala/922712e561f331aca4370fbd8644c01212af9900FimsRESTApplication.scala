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

package tv.amwa.ebu.fims.rest.rest
import scala.collection.JavaConversions.setAsJavaSet
import javax.ws.rs.core.{Application => JAXRSApplication}
import tv.amwa.ebu.fims.rest.rest.resource.JobContainerResource
import tv.amwa.ebu.fims.rest.engine.MemoryStoreOf
import tv.amwa.ebu.fims.rest.rest.message.JobXMLMessageBodyReader
import tv.amwa.ebu.fims.rest.rest.message.JobXMLMessageBodyWriter
import tv.amwa.ebu.fims.rest.rest.message.FullItemXMLMessageBodyWriter
import tv.amwa.ebu.fims.rest.rest.message.SummaryItemXMLMessageBodyWriter
import tv.amwa.ebu.fims.rest.rest.message.LinkItemXMLMessageBodyWriter
import tv.amwa.ebu.fims.rest.rest.message.HTTPErrorXMLMessageBodyWriter
import tv.amwa.ebu.fims.rest.rest.message.NodeXMLMessageBodyWriter
import tv.amwa.ebu.fims.rest.rest.message.JobJSONMessageBodyWriter
import tv.amwa.ebu.fims.rest.rest.message.JobJSONMessageBodyReader
import tv.amwa.ebu.fims.rest.rest.resource.BMContentContainerResource
import tv.amwa.ebu.fims.rest.rest.message.BMContentXMLMessageBodyWriter
import tv.amwa.ebu.fims.rest.rest.message.BMContentXMLMessageBodyReader
import tv.amwa.ebu.fims.rest.rest.handling.WebApplicationExceptionMapper
import tv.amwa.ebu.fims.rest.rest.message.FullItemJSONMessageBodyWriter
import tv.amwa.ebu.fims.rest.rest.message.SummaryItemJSONMessageBodyWriter
import tv.amwa.ebu.fims.rest.rest.message.BMContentJSONMessageBodyWriter
import tv.amwa.ebu.fims.rest.rest.message.HTTPErrorJSONMessageBodyWriter
import tv.amwa.ebu.fims.rest.rest.message.ManageJobXMLMessageBodyReader
import tv.amwa.ebu.fims.rest.rest.message.ManageQueueXMLMessageBodyReader
import tv.amwa.ebu.fims.rest.rest.message.ManageJobJSONMessageBodyReader
import tv.amwa.ebu.fims.rest.rest.message.ManageQueueJSONMessageBodyReader
import tv.amwa.ebu.fims.rest.rest.message.BMContentJSONMessageBodyReader
import tv.amwa.ebu.fims.rest.rest.message.StartProcessMessageBodyReader
import tv.amwa.ebu.fims.rest.rest.message.StopProcessMessageBodyReader

class FimsRESTApplication extends JAXRSApplication {
  
	override def getSingletons = Set[AnyRef](
	    new JobContainerResource(MemoryStoreOf.jobEngine),
	    new BMContentContainerResource(MemoryStoreOf.repository),
	    WebApplicationExceptionMapper,
	    HTTPErrorXMLMessageBodyWriter,
	    FullItemXMLMessageBodyWriter,
	    SummaryItemXMLMessageBodyWriter,
	    LinkItemXMLMessageBodyWriter,
	    JobXMLMessageBodyReader,
	    JobXMLMessageBodyWriter,
	    StartProcessMessageBodyReader,
	    StopProcessMessageBodyReader,
	    BMContentXMLMessageBodyWriter,
	    BMContentXMLMessageBodyReader,
	    BMContentJSONMessageBodyReader,
	    ManageJobXMLMessageBodyReader,
	    ManageJobJSONMessageBodyReader,
	    ManageQueueXMLMessageBodyReader,
	    ManageQueueJSONMessageBodyReader,
	    JobJSONMessageBodyWriter,
	    JobJSONMessageBodyReader,
	    BMContentJSONMessageBodyWriter,
	    HTTPErrorJSONMessageBodyWriter,
	    FullItemJSONMessageBodyWriter,
	    SummaryItemJSONMessageBodyWriter,
	    LinkItemXMLMessageBodyWriter,
	    new NodeXMLMessageBodyWriter
	) 
}