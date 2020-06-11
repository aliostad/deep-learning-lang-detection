package system.cell.processor.route.actors

import akka.actor.{ActorRef, Props}
import com.actors.TemplateActor
import system.names.NamingSystem
import system.ontologies.messages.Location._
import system.ontologies.messages.MessageType.Route
import system.ontologies.messages.MessageType.Route.Subtype.{Info, Response}
import system.ontologies.messages._

/**
  * This Actor manages the processing of Route from a cell A to a cell B.
  *
  * It either calculates the route from scratch or retrieves it from a caching actor
  *
  * Created by Alessandro on 11/07/2017.
  */
class RouteManager extends TemplateActor {
    
    private var cacher: ActorRef = _
    
    private var processor: ActorRef = _
    
    override def preStart: Unit = {
        super.preStart()
        cacher = context.actorOf(Props(new CacheManager(cacheKeepAlive = 2500L)), NamingSystem.CacheManager)
        processor = context.actorOf(Props(new RouteProcessor(parent)), NamingSystem.RouteProcessor)
    }
    
    override protected def receptive: Receive = {

        case AriadneMessage(Route, Info, _, info: RouteInfo) =>
            if (info.request.isEscape) manageEscape(info)
            else {
                log.info("Requesting route from Cache...")
                context.become(waitingForCache, discardOld = true)
                cacher ! info
            }
        case _ => desist _
    }
    
    private def waitingForCache: Receive = {
        case AriadneMessage(Route, Info, _, info: RouteInfo) =>
            if (info.request.isEscape) manageEscape(info) else stash
    
        case cnt@RouteInfo(_, _) if sender == cacher =>
            log.info("No cached route is present, sending data to Processor...")
            processor ! cnt
            context.become(receptive, discardOld = true)
            unstashAll
    
        case cnt@RouteResponse(_, _) if sender == cacher =>
            log.info("A valid cached route is present, sending data to Core...")
            parent ! AriadneMessage(
                Route,
                Response,
                Location.Cell >> Location.User,
                cnt
            )
            context.become(receptive, discardOld = true)
            unstashAll
    
        case _ => desist _
    }

    private val manageEscape = (cnt: RouteInfo) => {
        log.info("Escape route request received, becoming evacuating...")
        processor forward cnt
    }
}