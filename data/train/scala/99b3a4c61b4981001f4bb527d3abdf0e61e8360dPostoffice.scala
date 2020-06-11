package me.yzhi.twiggy.system

import akka.actor.{Actor, ActorRef, ActorSystem, Props}
import me.yzhi.twiggy.system.Node.NodeID
import me.yzhi.twiggy.util.PS.Key
import me.yzhi.twiggy.util.{FileUtils, Range}

import scala.concurrent.Promise

/**
 */
class Postoffice private {
  val yellowPages: YellowPages = _
  var app: AppContainer = _
  var appConf: String = _
  var appMsg: Message = _
  var finishedNodes = 0

  val system = ActorSystem("Postoffice")
  var receiver: ActorRef = _
  var sender: ActorRef = _
  var _done: Boolean = false

  val nodesAreDone = Promise[Unit]()
  val nodesAreReady = Promise[Unit]()
  val initAppPromise = Promise[Unit]()
  val runAppPromise = Promise[Unit]()

  def start(args: Array[String]) = {
    // TODO: parse args and store to CmdOptions
    yellowPages.init()
    myNode match {
      // FIXME
      case Node.SCHEDULER =>
        if (CmdOptions.appFile.isEmpty) {
          require(FileUtils.readFileToString(CmdOptions.appFile, appConf),
            "failed to read conf file %s" format CmdOptions.appFile)
        } else {
          appConf = CmdOptions.appConf
        }
        app = AppContainer.create(args)
        require(app != null, "failed to create %s with conf %s" format (CmdOptions.appName, CmdOptions.appConf))
      case _ =>
        // connect to the scheduler, which will send back a create_app request
        val task = new Task(opt=Task.MANAGE, request=true, time=0)
        task.mngNode = new ManageNode(ManageNode.CONNECT)
        task.mngNode.nodes :+= myNode
        val msg = new Message(task)
        msg.recver = yellowPages._van.scheduler.id
        send(msg)
    }

    receiver = system.actorOf(Props(new Receiver))
    sender = system.actorOf(Props(new Sender))

    myNode match {
      // FIXME
      case Node.SCHEDULER =>
        // add my node into app_
        // TODO: time = 0 ?
        val task = new Task(opt=Task.MANAGE, request=true, time=0)
        task.customer = app.name
        task.mngNode = new ManageNode(ManageNode.ADD)
        task.mngNode.nodes :+= myNode
        manageNode(task)
        // TODO: init other nodes
        if (CmdOptions.numWorkers + CmdOptions.numServers > 0) {
          // TODO: timeout
          nodesAreReady.future.wait()
          // LI << "Scheduler has connected " << FLAGS_num_servers << " servers and "
          // << FLAGS_num_workers << " workers";
          // wait until app has been created at all computation nodes
          app.port(PS.kCompGroup).waitOutgoingTask(1)

          // add all nodes into app
          var nodes = yellowPages.nodes
          nodes = Postmaster.partitionServerKeyRange(nodes, Range.all[Key])
          nodes = Postmaster.assignNodeRank(nodes)
          // task.set_request(true);
          val task = new Task(opt=Task.MANAGE, request=false, time=0)
          task.customer = app.name
          task.mngNode = new ManageNode(ManageNode.ADD)
          nodes.foreach(n => task.mngNode.nodes :+= n)
          // then add them in servers and workers
          app.port(PS.kCompGroup).submitAndWait(task, null)

          // init app
          val init = new Task(opt=Task.MANAGE, request=false, time=0)
          init.mngApp = new ManageApp(ManageApp.INIT)
          val initWait = app.port(PS.kCompGroup).submit(init)
          require(app != null)
          app.init()
          app.port(PS.kCompGroup).waitOutgoingTask(initWait)

          // run app
          val run = new Task(opt=Task.MANAGE, request=false, time=0)
          run.mngApp = new ManageApp(ManageApp.RUN)
          val runWait = app.port(PS.kCompGroup).submit(run)
          app.run()
          app.port(PS.kCompGroup).waitOutgoingTask(runWait)
        } else {
          require(app != null)
          app.init()
          app.run()
        }
      case _ =>
        // init app
        initAppPromise.future.wait()
        app.init()
        appMsg.finished = true
        finish(appMsg)

        // run app
        runAppPromise.future.wait()
        app.run()
        appMsg.finished = true
        finish(appMsg)
    }
  }

  def stop(): Unit = {
    myNode match {
      // FIXME
      case Node.SCHEDULER =>
        if (CmdOptions.numWorkers + CmdOptions.numServers > 0) {
          nodesAreDone.future.wait()
        }
        val terminate = new Task(opt=Task.TERMINATE)
        app.port(PS.kLiveGroup).submit(terminate)
        Thread.sleep(800)
        // TODO: LI << "System stopped\n";
      case _ =>
        val done = new Task(opt=Task.MANAGE)
        done.mngApp = new ManageApp(ManageApp.DONE)
        app.port(app.schedulerID).submit(done)
        // run as a daemon until received the termination messag
        while (!_done) Thread.sleep(300)
    }
  }

  def finish(msg: Message): Unit = {
    if (msg.finished) {
      val obj = yellowPages.customer(msg.task.customer)
      obj.foreach(_.exec.finish(msg))
      reply(msg.sender, msg.task)
    }
  }

  def reply(recver: NodeID, task: Task, replyMsg: String = ""): Unit = {
    if (!task.request) return
    val tk = new Task(opt=Task.REPLY, request=false, time=task.time)
    tk.customer = task.customer
    if (!replyMsg.isEmpty) {
      tk.setMessage(replyMsg)
    }
    val re = new Message(tk)
    re.recver = recver
    send(re)
  }

  def manageApp(msg: Message): Unit = {
    val tk = msg.task
    require(tk.mngApp != null)
    val cmd = tk.mngApp.cmd
    cmd match {
      case ManageApp.ADD =>
        app = AppContainer.create(tk.customer, tk.mngApp.conf)
        // yp().depositCustomer(app->name());
      case ManageApp.INIT =>
        msg.finished = false
        if (appMsg == null) {
          appMsg = new Message(msg)
        }
        initAppPromise.success()
      case ManageApp.RUN =>
        msg.finished = false
        if (appMsg == null) {
          appMsg = new Message(msg)
        }
        runAppPromise.success()
      case ManageApp.DONE =>
        finishedNodes += 1
        if (finishedNodes >= CmdOptions.numWorkers + CmdOptions.numServers) {
          nodesAreDone.success()
        }
    }
  }

  def manageNode(tk: Task): Unit = {
    // CHECK(tk.has_mng_node());
    val mng = tk.mngNode
    mng.cmd match {
      case ManageNode.CONNECT =>
        // FIXME:
        require(myNode == Node.SCHEDULER)
        // TODO: CHECK_EQ(mng.node_size(), 1);
        // first add this node into app
        val add = tk
        require(app.name != null)
        add.customer = app.name
        val mngNode = new ManageNode(ManageNode.ADD)
        add.mngNode = mngNode
        manageNode(add)
        // create the app in this node
        val task = new Task(request=true, opt=Task.MANAGE, time=1)
        task.customer = app.name
        task.mngApp = new ManageApp(ManageApp.ADD)
        task.mngApp.conf = appConf
        app.port(mng.nodes.head.id).submit(task)
        // check if all nodes are connected
        if (yellowPages.numWorkers >= CmdOptions.numWorkers &&
          yellowPages.numServers >= CmdOptions.numServers) {
          nodesAreReady.success()
        }
        tk.customer = app.name // otherwise the remote node doesn't know
        // how to find the according customer
      case ManageNode.ADD | ManageNode.UPDATE =>
        val obj = yellowPages.customer(tk.customer)
        require(obj != None, "customer [" + tk.customer + "] doesn't exists")
        mng.nodes.foreach(node => {
          yellowPages.addNode(node)
          obj.get.exec.add(node)
          yellowPages.children(obj.get.name).foreach(_.foreach(c => {
            val child = yellowPages.customer(c)
            child.foreach(_.exec.add(node))
          }))
        })
      case ManageNode.REPLACE =>
      case ManageNode.REMOVE =>
        // do nothing
    }
  }

  def send(msg: Message) {
    if (msg.valid && !msg.terminate) {
      val stat = yellowPages._van.send(msg)
      for (s <- stat if s.ok) {
        // heartbeat_info_.increaseOutBytes(send_bytes);
        return
      }
      // TODO: log failure
    } else {
      // TODO: do not send, fake a reply mesage
    }
  }

  private def myNode = {
    yellowPages._van.myNode
  }

  class Receiver extends Actor {
    // TODO
    override def receive: Receive = ???
  }

  class Sender extends Actor {
    // TODO
    override def receive: Receive = ???
  }
}

object Postoffice {
  val instance = new Postoffice()
}
