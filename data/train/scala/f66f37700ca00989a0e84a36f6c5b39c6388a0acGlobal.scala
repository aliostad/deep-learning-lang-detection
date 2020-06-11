import org.camunda.bpm.engine.{ProcessEngineConfiguration, ProcessEngines}
import play.api.{Application, GlobalSettings, Logger}

object Global extends GlobalSettings {

  /**
   * Start the camunda BPM process engine and deploy process definitions on start-up.
   */
  override def onStart(application: Application): Unit = {
    val configuration = ProcessEngineConfiguration.createStandaloneProcessEngineConfiguration()
      .setJdbcDriver("org.postgresql.Driver")
      .setJdbcUrl("jdbc:postgresql://localhost/process-engine")
      .setJdbcUsername("camunda")
      .setJdbcPassword("camunda")
      .setDatabaseSchemaUpdate(ProcessEngineConfiguration.DB_SCHEMA_UPDATE_TRUE)
      .setHistory(ProcessEngineConfiguration.HISTORY_AUDIT)
      .setJobExecutorActivate(true)

    Logger.info("Starting process engine...")
    val engine = configuration.buildProcessEngine()

    Logger.info("Deploying process definition...")
    val deployment = engine.getRepositoryService.createDeployment()
    deployment.addClasspathResource("loan-approval.bpmn").enableDuplicateFiltering(true)
    deployment.deploy()
  }

  override def onStop(application: Application): Unit = {
    ProcessEngines.getDefaultProcessEngine.close()
  }
}
