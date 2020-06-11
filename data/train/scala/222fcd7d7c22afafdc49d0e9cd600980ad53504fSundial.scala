package service

import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.{AtomicBoolean, AtomicLong}
import java.util.{Date, UUID}
import javax.inject.{Inject, Singleton}

import dao._
import model._
import play.api.inject.ApplicationLifecycle

import scala.concurrent.Future
import scala.util.control.NonFatal

case class MetricValues(wakes: Long, steps: Long, processStarts: Long, taskStarts: Long, processFinishes: Long, processTerminations: Long)

// mostly for verifying test cases
class SundialMetrics {
  val wakes = new AtomicLong()
  val steps = new AtomicLong()
  val processStarts = new AtomicLong()
  val taskStarts = new AtomicLong()
  val processFinishes = new AtomicLong()
  val processTerminations = new AtomicLong()

  def values = MetricValues(wakes.get(), steps.get(), processStarts.get(), taskStarts.get(), processFinishes.get(), processTerminations.get())

  override def toString: String = {
    s"SundialMetrics(wakes=$wakes, steps=$steps, processStarts=$processStarts, taskStarts=$taskStarts, processFinishes=$processFinishes, processTerminations=$processTerminations)"
  }
}

sealed trait RunReason
case class ScheduleRunReason(schedule: ProcessSchedule) extends RunReason
case class ProcessTriggerRunReason(request: ProcessTriggerRequest) extends RunReason
case class TaskTriggerRunReason(request: TaskTriggerRequest) extends RunReason

// globally single-threaded coordinator
// wakes up frequently to do work
// individual processes run in separate threads
// those threads are joined before continuing
// executions of doWork() should be very fast (a few seconds)
@Singleton
class Sundial @Inject() (
  globalLock: GlobalLock,
  processStepper: ProcessStepper,
  daoFactory: SundialDaoFactory,
  applicationLifecycle: ApplicationLifecycle
) {

  val metrics = new SundialMetrics()

  val stopped = new AtomicBoolean(true)

  start(10, TimeUnit.SECONDS)

  def start(refreshTime: Int, refreshUnits: TimeUnit): Unit = {
    stopped.set(false)
    val delayMs = refreshUnits.toMillis(refreshTime)
    //TODO Replace with sane timer class
    new Thread {

      this.setDaemon(true)

      override def run(): Unit = {
        while(!stopped.get()) {
          Thread.sleep(delayMs)
          try {
            doWork()
          } catch {
            case NonFatal(e) => e.printStackTrace() // TODO log error
          }
        }
      }

    }.start()

    applicationLifecycle.addStopHook { () =>
      Future.successful(stop())
    }
  }

  def stop(): Unit = {
    stopped.set(true)
  }

  def doWork(): Unit = {
    globalLock.executeGuarded() {
      metrics.wakes.incrementAndGet()

      // first, step processes that are currently running
      val runningProcesses = stepRunningProcesses

      // use a temporary dao to load process definitions
      val processDefinitions = daoFactory.withSundialDao { dao =>
        dao.processDefinitionDao.loadProcessDefinitions()
      }

      // then, check for any processes scheduled to run that have not yet run
      processDefinitions.par.foreach { processDefinition =>
        processProcessDefinition(processDefinition, runningProcesses)
      }
    }
  }

  private def processProcessDefinition(processDefinition: ProcessDefinition, runningProcesses: Seq[Process]) = {
    daoFactory.withSundialDao { dao =>
      // if the start of the last run was before the most recently scheduled run time,
      // we are scheduled to run
      // if the task has never run before, we use the time that the process definition
      // was created; if the process runs at 4PM, and we create it at 3PM, it runs an hour
      // later, so the create time is in effect the earliest actual run time
      val mostRecent = dao.processDao.loadMostRecentProcess(processDefinition.name)

      determineProcessDefinitionRunReason(processDefinition, mostRecent, dao).foreach { reason =>
        val isCurrentlyRunning = isRunning(mostRecent)
        val isProcessAbleToRun = canRun(processDefinition, runningProcesses, mostRecent, isCurrentlyRunning)
        (isCurrentlyRunning, isProcessAbleToRun) match {
          case (true, _) => handleOverlap(processDefinition, mostRecent, reason, dao)
          case (false, true) => startProcess(processDefinition, reason, dao)
          case (_, false) => // No op
        }
      }
    }
  }

  private def handleOverlap(processDefinition: ProcessDefinition, mostRecentExecutionOption: Option[Process], runReason: RunReason, dao: SundialDao) = (processDefinition.overlapAction, mostRecentExecutionOption) match {
    case (ProcessOverlapAction.Terminate, Some(mostRecentExecution)) => {
      dao.triggerDao.saveKillProcessRequest(KillProcessRequest(UUID.randomUUID(), mostRecentExecution.id, new Date(System.currentTimeMillis())))
      // Step the process first, to kill its current task
      processStepper.step(mostRecentExecution, dao, metrics)
      // Then, start a new process for the process definition
      startProcess(processDefinition, runReason, dao)
    }
    case (_, _) => // No op; this covers the "wait" overlap action.
  }

  private def startProcess(processDefinition: ProcessDefinition, reason: RunReason, dao: SundialDao) = {
    metrics.processStarts.incrementAndGet()
    val baseProcess = Process(id = UUID.randomUUID(),
      processDefinitionName = processDefinition.name,
      startedAt = new Date(),
      status = ProcessStatus.Running())

    createRunningTaskDefinitionsFromTemplate(processDefinition, baseProcess.id, dao)

    val process = reason match {
      case TaskTriggerRunReason(request) => {
        val savedProcess = dao.processDao.saveProcess(baseProcess.copy(taskFilter = Some(Seq(request.taskDefinitionName))))
        dao.triggerDao.saveTaskTriggerRequest(request.copy(startedProcessId = Some(savedProcess.id)))
        savedProcess
      }
      case ProcessTriggerRunReason(request) => {
        request match {
          case ProcessTriggerRequest(_, _, _, Some(filter), _) => {
            val savedProcess = dao.processDao.saveProcess(baseProcess.copy(taskFilter = Some(filter)))
            dao.triggerDao.saveProcessTriggerRequest(request.copy(startedProcessId = Some(savedProcess.id)))
            savedProcess
          }
          case _ => {
            val savedProcess = dao.processDao.saveProcess(baseProcess)
            dao.triggerDao.saveProcessTriggerRequest(request.copy(startedProcessId = Some(savedProcess.id)))
            savedProcess
          }
        }
      }
      case _ =>
        dao.processDao.saveProcess(baseProcess)
    }

    dao.ensureCommitted()

    // take its first step – ok to re-use our dao
    processStepper.step(process, dao, metrics)
  }

  private def createRunningTaskDefinitionsFromTemplate(processDefinition: ProcessDefinition, processId: UUID, dao: SundialDao): Unit = {
    val taskDefinitionTemplates = dao.processDefinitionDao.loadTaskDefinitionTemplates(processDefinition.name)
    taskDefinitionTemplates.foreach { taskDefinitionTemplate =>
      val taskDefinition = TaskDefinition(
        taskDefinitionTemplate.name,
        processId,
        taskDefinitionTemplate.executable,
        taskDefinitionTemplate.limits,
        taskDefinitionTemplate.backoff,
        taskDefinitionTemplate.dependencies,
        taskDefinitionTemplate.requireExplicitSuccess
      )
      dao.processDefinitionDao.saveTaskDefinition(taskDefinition)
    }
  }

  private def determineProcessDefinitionRunReason(processDefinition: ProcessDefinition, mostRecent: Option[Process], dao: SundialDao): Option[RunReason] = {
    val lastRun = mostRecent
      .map(_.startedAt)
      .getOrElse(processDefinition.createdAt)

    // TODO We should buffer in order to avoid issues caused by clock skew
    // is the next run of this process before now?
    val scheduleToRun = processDefinition.schedule.flatMap { schedule =>
      if (schedule.nextRunAfter(lastRun).before(new Date())) {
        Some(schedule)
      } else {
        None
      }
    }
    val processTriggers = dao.triggerDao.loadOpenProcessTriggerRequests()
    // manual triggers
    val nextProcessTrigger = processTriggers
      .filter(_.processDefinitionName == processDefinition.name)
      .sortBy(_.requestedAt)
      .headOption
    val taskTriggers = dao.triggerDao.loadOpenTaskTriggerRequests()
    val nextTaskTrigger = taskTriggers
      .filter(_.processDefinitionName == processDefinition.name)
      .sortBy(_.requestedAt)
      .headOption
    (scheduleToRun, processDefinition.isPaused, nextProcessTrigger, nextTaskTrigger) match {
      case (Some(schedule), false, _, _) =>
        Some(ScheduleRunReason(schedule))
      case (_, _, Some(processTrigger), _) =>
        Some(ProcessTriggerRunReason(processTrigger))
      case (_, _, _, Some(taskTrigger)) =>
        Some(TaskTriggerRunReason(taskTrigger))
      case _ =>
        None
    }
  }

  private def isRunning(mostRecentExecution: Option[Process]): Boolean = {
    mostRecentExecution.exists { process =>
      process.status match {
        case ProcessStatus.Running() => true
        case _ => false
      }
    }
  }

  /**
    * Returns true if the the provided process definition is able to be executed and false if not.
    */
  private def canRun(processDefinition: ProcessDefinition, runningProcesses: Seq[Process], mostRecentExecution: Option[Process], isCurrentlyRunning: Boolean): Boolean = {
    val justRan = runningProcesses.map(_.processDefinitionName).contains(processDefinition.name)
    !justRan && !isCurrentlyRunning
  }

  /**
    * Loads all currently running processes, and steps each of them.
    */
  private def stepRunningProcesses: Seq[Process] = {
    // we need a temporary dao to load the running processes
    // we use a par below, so it can't be reused
    val runningProcesses = daoFactory.withSundialDao { dao =>
      dao.processDao.loadRunningProcesses()
    }

    runningProcesses.par.foreach { process =>
      daoFactory.withSundialDao { dao =>
        processStepper.step(process, dao, metrics)
      }
    }
    runningProcesses
  }
}
