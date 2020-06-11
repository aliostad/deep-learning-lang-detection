package bmpattern

import scala.concurrent.duration._
import akka.actor.Actor
import akka.actor.ActorLogging
import akka.actor.ActorRef
import akka.actor.Props
import bmlogic.aggregateCalc.{AggregateModule, msg_AggregateCommand}
import bmlogic.adjustdata.{AdjustDataModule, msg_AdjustDataCommand}
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import play.api.libs.json.JsValue
import play.api.libs.json.Json.toJson
import bmmessages._
import bmlogic.auth.{AuthModule, msg_AuthCommand}
import bmlogic.category.{CategoryModule, msg_CategoryCommand}
import bmlogic.config.{ConfigModule, msg_ConfigCommand}
import bmlogic.sampleData.{SampleDataModule, msg_SampleDataCommand}
import bmlogic.report.{ReportModule, msg_ReportCommand}
import bmlogic.retrieval.{RetrievalModule, msg_RetrievalCommand}
import bmlogic.userManage.{UserManageModule, msg_UserManageCommand}
import bmlogic.userManage.{QueryUserModule, msg_QueryUserCommand}
import bmlogic.loginLog.{LoginLogModule, msg_LoginLogCommand}


object PipeFilterActor {
	def prop(originSender : ActorRef, msr : MessageRoutes) : Props = {
		Props(new PipeFilterActor(originSender, msr))
	}
}

class PipeFilterActor(originSender : ActorRef, msr : MessageRoutes) extends Actor with ActorLogging {
    implicit val cm = msr.cm
	
	def dispatchImpl(cmd : CommonMessage, module : ModuleTrait) = {
		tmp = Some(true)
		module.dispatchMsg(cmd)(rst) match {
			case (_, Some(err)) => {
				originSender ! error(err)
				cancelActor
			}
			case (Some(r), _) => {
//				println(r)
				rst = Some(r) 
			}
			case _ => println("never go here")
		}
		rstReturn
	}
	
	var tmp : Option[Boolean] = None
	var rst : Option[Map[String, JsValue]] = msr.rst
	var next : ActorRef = null
	def receive = {
		case cmd : msg_AuthCommand => dispatchImpl(cmd, AuthModule)
		case cmd : msg_RetrievalCommand => dispatchImpl(cmd, RetrievalModule)
		case cmd : msg_AggregateCommand => dispatchImpl(cmd, AggregateModule)
		case cmd : msg_AdjustDataCommand => dispatchImpl(cmd, AdjustDataModule)
		case cmd : msg_ResultCommand => dispatchImpl(cmd, ResultModule)
        case cmd : msg_LogCommand => dispatchImpl(cmd, LogModule)
		case cmd : msg_ConfigCommand=>dispatchImpl(cmd,ConfigModule)
		case cmd : msg_CategoryCommand=>dispatchImpl(cmd,CategoryModule)
		case cmd : msg_ReportCommand => dispatchImpl(cmd, ReportModule)
		case cmd : msg_UserManageCommand => dispatchImpl(cmd, UserManageModule)
		case cmd : msg_QueryUserCommand => dispatchImpl(cmd, QueryUserModule)
		case cmd : msg_LoginLogCommand => dispatchImpl(cmd, LoginLogModule)
		case cmd : msg_SampleDataCommand => dispatchImpl(cmd,SampleDataModule)
		case cmd : ParallelMessage => {
		    cancelActor
			next = context.actorOf(ScatterGatherActor.prop(originSender, msr), "scat")
			next ! cmd
		}
		case timeout() => {
			originSender ! new timeout
			cancelActor
		}
	 	case x : AnyRef => println(x); ???
	}
	
	val timeOutSchdule = context.system.scheduler.scheduleOnce(20 minute, self, new timeout)

	def rstReturn = tmp match {
		case Some(_) => { rst match {
			case Some(r) => 
				msr.lst match {
					case Nil => {
						originSender ! result(toJson(r))
					}
					case head :: tail => {
						head match {
							case p : ParallelMessage => {
								next = context.actorOf(ScatterGatherActor.prop(originSender, MessageRoutes(tail, rst)), "scat")
								next ! p
							}
							case c : CommonMessage => {
								next = context.actorOf(PipeFilterActor.prop(originSender, MessageRoutes(tail, rst)), "pipe")
								next ! c
							}
						}
					}
					case _ => println("msr error")
				}
				cancelActor
			case _ => Unit
		}}
		case _ => println("never go here"); Unit
	}
	
	def cancelActor = {
		timeOutSchdule.cancel
//		context.stop(self)
	}
}