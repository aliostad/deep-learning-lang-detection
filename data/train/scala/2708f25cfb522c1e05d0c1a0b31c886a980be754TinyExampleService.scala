import com.codahale.fig.Configuration
import com.yammer.dropwizard.{Environment, Service}

/**
 * A Service provides a program entry point via the main function.
 * On startup, the configuration file passed via the command line
 * is parsed by fig and passed to the service in configure.
 */

object TinyExampleService extends Service {
  def name = "TinyExample"

  // Usually you'll want to override banner too
  override def banner = Some("This gets printed on service startup")

  def configure(implicit config: Configuration, environment: Environment) { 
    /** Here you can add things to dropwizard startup via methods on environment
     * eg:
     * environment.manage(new MyManagedClass)
     * environment.addHealthCheck(new TinyHelpCheck)
     */
  }
}
