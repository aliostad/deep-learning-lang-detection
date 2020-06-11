package net.eamelink.akkaflow

import scala.concurrent.{ Await, Future }
import scala.concurrent.duration.DurationInt

import org.scalatest.{ BeforeAndAfter, FunSpec }

import akka.actor._
import akka.pattern.ask
import akka.testkit.TestProbe
import akka.util.Timeout
import net.eamelink.akkaflow.ProcessDefActor.{ ProcessEvent, ProcessFinished, ProcessStarted, StartProcess }
import net.eamelink.akkaflow.ProcessInstanceActor.GetVariables
import net.eamelink.akkaflow.util.ProcessParser

class ProcessDefSpec extends FunSpec with BeforeAndAfter {

  implicit val timeout = Timeout(1.seconds)
  implicit var system: ActorSystem = _

  before {
    system = ActorSystem("bpmn")
  }

  after {
    system.shutdown()
  }

  val process = ProcessParser.parseProcess(
    <process id="testProcess" name="TestProcess" isExecutable="true">
      <startEvent id="startevent1" name="Start"></startEvent>
      <sequenceFlow id="flow1" sourceRef="startevent1" targetRef="endevent1"></sequenceFlow>
      <endEvent id="endevent1" name="End"></endEvent>
    </process>)

  val processWithWait = ProcessParser.parseProcess(
    <process id="testProcess" name="TestProcess" isExecutable="true">
      <startEvent id="startevent1" name="Start"></startEvent>
      <sequenceFlow id="flow1" sourceRef="startevent1" targetRef="usertask1"></sequenceFlow>
      <userTask id="usertask1" name="UserTask1"></userTask>
      <sequenceFlow id="flow1" sourceRef="usertask1" targetRef="usertask1"></sequenceFlow>
      <endEvent id="endevent1" name="End"></endEvent>
    </process>)

  describe("A process") {
    it("can be started without process variables") {
      val processDefActor = system.actorOf(Props(classOf[ProcessDefActor], process), name = "process")
      val myProcessRef = processDefActor ? StartProcess()
      assert(myProcessRef.isInstanceOf[Future[_]])
    }

    it("sends a ProcessStarted event over the eventstream when it started") {
      val probe1 = TestProbe()
      system.eventStream.subscribe(probe1.ref, classOf[ProcessEvent])

      val processDefActor = system.actorOf(Props(classOf[ProcessDefActor], process), name = "process")
      val myProcessRef = processDefActor ? StartProcess()
      assert(myProcessRef.isInstanceOf[Future[_]])

      val processInstance = probe1.expectMsgPF(500.millis) { case ProcessStarted(processInstance) ⇒ processInstance }
    }

    it("sends a ProcessFinished event over the eventstream when it ended") {
      val probe1 = TestProbe()
      system.eventStream.subscribe(probe1.ref, classOf[ProcessEvent])

      val processDefActor = system.actorOf(Props(classOf[ProcessDefActor], process), name = "process")
      val myProcessRef = processDefActor ? StartProcess()
      assert(myProcessRef.isInstanceOf[Future[_]])

      val processInstance1 = probe1.expectMsgPF(500.millis) { case ProcessStarted(processInstance) ⇒ processInstance }
      val processInstance2 = probe1.expectMsgPF(500.millis) { case ProcessFinished(processInstance, _) ⇒ processInstance }
      assert(processInstance1 == processInstance2)
    }

    it("can be started with process variables") {
      val processDefActor = system.actorOf(Props(classOf[ProcessDefActor], process), name = "process")
      val myProcessRef = processDefActor ? StartProcess(Map("foo" -> "bar"))
      assert(myProcessRef.isInstanceOf[Future[_]])
    }

    it("sends a ProcessFinished event containing the variables over the eventstream when it ended") {
      val probe1 = TestProbe()
      system.eventStream.subscribe(probe1.ref, classOf[ProcessEvent])

      val processDefActor = system.actorOf(Props(classOf[ProcessDefActor], process), name = "process")
      val variables1 = Map("foo" -> "bar")
      val myProcessRef = processDefActor ? StartProcess(variables1)
      assert(myProcessRef.isInstanceOf[Future[_]])

      val processInstance1 = probe1.expectMsgPF(500.millis) { case ProcessStarted(processInstance) ⇒ processInstance }
      val (processInstance2, variables2) = probe1.expectMsgPF(500.millis) { case ProcessFinished(processInstance, variables) ⇒ (processInstance, variables) }
      assert(processInstance1 == processInstance2)
      assert(variables1 == variables2)
    }
  }

  describe("A process with a wait state") {
    it("has the process variables with which it is started") {
      val processDefActor = system.actorOf(Props(classOf[ProcessDefActor], processWithWait), name = "process")

      // TODO, is this the right way?
      implicit val ec = system.dispatcher

      val variables = Await.result(
        for (
          actorRef ← (processDefActor ? StartProcess(Map("foo" -> "bar"))).mapTo[ActorRef];
          variables ← (actorRef ? GetVariables).mapTo[Map[String, String]]
        ) yield variables,
        500.millis)

      assert(variables.get("foo") == Some("bar"))
    }
  }

}