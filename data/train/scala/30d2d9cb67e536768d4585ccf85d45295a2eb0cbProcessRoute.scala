package pl.edu.agh.volup.register.rest.server.route

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import pl.edu.agh.volup.register.dto.ProcessDto
import pl.edu.agh.volup.register.service.{ProcessService, UserService}

import pl.edu.agh.volup.register.model.Process
import pl.edu.agh.volup.register.rest.server.route.ProcessRoute._

@Service
class ProcessRoute @Autowired()(processService: ProcessService, userService: UserService) extends
JsonSupportRoute {
  val route =
    path("process") {
      //get oldest process
      get {
        complete {
          processService.oldest() match {
            case Some(q) => complete(toDto(q))
            case None => reject()
          }
        }
      }
    } ~
      path("process" / "all") {
        // get all processes
        get {
          complete(processService.getAll().map(toDto).toList)
        }
      }
}

object ProcessRoute {

  def toDto(process: Process): ProcessDto = ProcessDto(process.address.toString(false), process.encodedDomainKey.toList)

}
