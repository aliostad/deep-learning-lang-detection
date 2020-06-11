package template.rest

import org.codehaus.jackson.map.ObjectMapper
import javax.ws.rs.core.Response
import java.io.IOException
import javax.ws.rs._

@Path("dump")
class Dump {
  @GET
  @Path("{param}")
  @Produces(Array("application/json"))
  def dump(@PathParam("param") param: String): Response = {
    val mapper: ObjectMapper = new ObjectMapper
    val dump: template.model.Dump = new template.model.Dump
    dump.message = Stats.getDumpageStr()
    try {
      return Response.status(200).entity(mapper.writeValueAsString(dump)).build
    }
    catch {
      case e: IOException => {
        e.printStackTrace
        return Response.status(500).entity(e.getMessage).build
      }
    }
  }
}
