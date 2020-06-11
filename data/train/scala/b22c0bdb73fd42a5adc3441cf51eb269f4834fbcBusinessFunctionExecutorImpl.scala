package omed.bf

import java.util.logging.Logger
import java.util.UUID
import com.google.inject.{Injector, Inject}

import omed.system.ContextProvider
import omed.db.{DBProfiler, ConnectionProvider}
import omed.model._
import collection.mutable
import omed.model.services.ExpressionEvaluator
import omed.validation.ValidationProvider
import com.sun.org.apache.xerces.internal.impl.dv.ValidationContext
import omed.lang.eval.ValidatorContext
import omed.errors.ValidationException
import ru.atmed.omed.beans.model.meta.CompiledValidationRule
import omed.cache.ExecStatProvider
import omed.bf.BusinessFunctionStepLog

class BusinessFunctionExecutorImpl extends BusinessFunctionExecutor {
  val logger = Logger.getLogger(this.getClass.getName())
  @Inject
  var functionInfoProvider: FunctionInfoProvider = null
  @Inject
  var processStateProvider: ProcessStateProvider = null
  @Inject
  var contextProvider: ContextProvider = null
  @Inject
  var connectionProvider: ConnectionProvider = null
  @Inject
  var serverStepExecutor: ServerStepExecutor = null
  @Inject
  var clientResultParser: ClientResultParser = null

  @Inject
  var expressionEvaluator:ExpressionEvaluator = null

  @Inject
  var validationProvider:ValidationProvider = null

  @Inject
  var businessFunctionLogger:BusinessFunctionLogger = null
  
  @Inject
  var businessFunctionThreadPool:BusinessFunctionThreadPool = null

  @Inject
  var entityDataProvider:EntityDataProvider = null
  @Inject
  var model:MetaModel = null

  @Inject
  var validationWarningPool:ValidationWarningPool = null
  @Inject
  var execStatProvider :ExecStatProvider = null

  def initFunctionInstance(
    functionId: String,
    params: Map[String, Value] = Map()): String = {

    val functionInfo= functionInfoProvider.getFunctionInfo(functionId).get

    if( businessFunctionThreadPool.containBF(functionId)){
       val stack = businessFunctionThreadPool.pool
       val msg = "рекурсивный вызов БФ: "+ functionInfo.name +"\n"+ stack.map(f=> functionInfoProvider.getFunctionInfo(f).get.name).toString()
      throw new RuntimeException(msg)
    }
    try{
      businessFunctionThreadPool.addBF(functionId)
      val msg = String.format("Initiating business function %s with steps:\n%s",
        functionInfo.name,
        functionInfo.steps.map(_.description.toString()).mkString("\n")
      )
      logger.info(msg)

      // получаем идентификаторы процесса
      val processId = UUID.randomUUID().toString.toUpperCase
      if(!businessFunctionThreadPool.getRootProcessId.isDefined) businessFunctionThreadPool.setRootProcessId(processId)
      val sessionId = contextProvider.getContext.sessionId
      businessFunctionLogger.addLogStep(businessFunctionThreadPool.getRootProcessId.get,new BusinessFunctionStepLog("init BF " + functionInfo.name +" bfID = "+ functionInfo.id,params++Map("steps"->SimpleValue(msg))),contextProvider.getContext)
      // инициализация системных переменных
      val systemParams = contextProvider.getContext.getSystemVariables

      //заменяем guidы объектами
      // исключение для БФ восстанавливающей удаленные объекты
     val updatedParams = if(functionId!="7C729D3E-8782-4268-8E2B-2B2286C546EE") expressionEvaluator.convertGuidsToObject(params)
                           else params
      // создаем и регистрируем процесс
      val thisObject = updatedParams.get("this")
      if(thisObject.isDefined){
        val (errors,warnings )= validationProvider.getComlpexBFValidators(functionId,Map("this"->thisObject.get))
        if(!errors.isEmpty) throw new ValidationException(false,(validationWarningPool.getWarnings).toSeq)
      }


      val process = ProcessFactory.createProcess(functionInfo, processId, sessionId, updatedParams ++ systemParams)
      processStateProvider.putProcess(processId, process)

      // запускаем выполнение
      exec(process)

      processId
    }
    finally {
      businessFunctionThreadPool.deleteBF
    }
  }

  def getNextClientStep(processId: String): (Option[ClientTask],Option[Value]) = {
    val processInfo = processStateProvider.getProcess(processId)
    val result =if(processInfo.isDefined){
      val process = processInfo.get
      val resultName = functionInfoProvider.getFunctionInfo(process.functionId).get.resultName
      if(resultName!=null) process.context.get(resultName.replaceFirst("\\@", "")).getOrElse(null)
      else null
    }
    else null

    val step = if (processInfo.isDefined) {
      val process = processInfo.get

      if (process.state == ProcessStateType.Finished) {
        null
      } else {
        process.tasks.head.asInstanceOf[ClientTask]
      }
    } else null

    (Option(step),Option(result))
  }

  def getContext(processId: String): Map[String, Value] = {
    val processInfo = processStateProvider.getProcess(processId)
    if (processInfo.isDefined) {
      val process = processInfo.get
      process.context
    } else Map()
  }

  def getFalseValidations(processId: String):  Set[CompiledValidationRule]={
    val processInfo = processStateProvider.getProcess(processId)
    if (processInfo.isDefined) {
      val process = processInfo.get
      process.falseValidators
    } else Set()
  }
  def setFalseValidations(processId: String, validators:Set[CompiledValidationRule]){
    val processInfo = processStateProvider.getProcess(processId)
    if (processInfo.isDefined) {
      val process = processInfo.get
      process.falseValidators = validators
    }
  }
  def setClientResult(processId: String, clientMessage: String): Unit = {
    val process = processStateProvider.getProcess(processId).get

    // обновить информацию о процессе, если процесс ожидает окончание выполнения шага
    if (process.state == ProcessStateType.Waiting) {
      val clientTask = process.tasks.head


      try {
        // прочитать переменные из полученного сообщения
        val clientResult = clientResultParser.parse(clientTask, clientMessage)
        businessFunctionThreadPool.setRootProcessId(processId)

        // обновляем провайдеры доступа к БД
        process.context.values.foreach( f => f match {
          case e:EntityInstance => {
            e.dataProvider = entityDataProvider
            e.model = model
          }
          case _ =>
        })
        // обновить контекст
        val updatedContext = process.context ++ clientResult
        val leftTasks = process.tasks.tail

        process.context = updatedContext
        process.tasks = leftTasks
        process.state = if (leftTasks.isEmpty)
          ProcessStateType.Finished
        else ProcessStateType.Running
      } catch {
        // в случае исключений при разборе полученного значения останавливаем выполнение
        case _ => process.state = ProcessStateType.Finished
      }

      // продолжить выполнение процесса
      exec(process)
    } else {
      val msg = "No client result expected at this moment"
      throw new RuntimeException(msg)
    }
  }

  private def exec(process: ProcessState) {
    if (process.state == ProcessStateType.Finished) {
      logger.info("BF with ID=" + process.functionId + " going to stop")
     // processStateProvider.dropProcess(process.id)
    } else {
      run(process)
      processStateProvider.putProcess(process.id, process)
    }
  }

  /**
   * Выполнить серверные шаги функции до следующего клиентского
   */
  private def run(process: ProcessState): Unit = {
    if (process.state != ProcessStateType.Running)
      return

    // execute all steps in one transaction
    connectionProvider.inTransaction {
      connection => try {
        do {
          // инициализируем начальное значение описания текущего шага
          var task = process.tasks.head

          logger.info(String.format(
            "Executing BF task (" +
              "ProcessId: %s, StepType: %s, Context variables: [%s])",
              process.id, task.stepType, process.context.keySet.mkString(", ")))
          val rootProcessId = businessFunctionThreadPool.getRootProcessId.getOrElse(process.id)
          if (task.isInstanceOf[ClientTask]) {
            // если текущий шаг является клиентским
            // приостанавливаем выполнение процесса
            //process.context
            process.state = ProcessStateType.Waiting
          } else {
            if (serverStepExecutor.canHandle(task)) {
              // иначе выполняем шаг на сервере
              DBProfiler.profile(task.stepType,execStatProvider,true){
                  val taskResult = serverStepExecutor.execute(task, process.context,rootProcessId)
                  val updatedContext = process.context ++ taskResult
                  process.context = updatedContext
              }
            } else {
              val msg = "Неизвестный шаг бизнес-функции " + task.stepType
              throw new omed.errors.MetaModelError(msg)
            }

            val leftTasks = process.tasks.tail
            process.tasks = leftTasks
            process.state = if (leftTasks.isEmpty)
              ProcessStateType.Finished
            else ProcessStateType.Running
          }
        } while (process.state == ProcessStateType.Running)
      } catch {
        case e =>{  // @ _ => {
        var task = process.tasks.head
        val rootProcessId = businessFunctionThreadPool.getRootProcessId.getOrElse(process.id)
          businessFunctionLogger.addLogStep(rootProcessId,new BusinessFunctionStepLog("Exception",params=Map("message"->SimpleValue(e.getMessage),"step"->SimpleValue(task.description),"log"->SimpleValue(e.getStackTrace.mkString("\n")))))

          logger.info("BF with ID=" + process.functionId + " halted")
          processStateProvider.dropProcess(process.id)
          throw e
        }
      }
    }
  }
}