package com.jkbff.ao.tyrbot

import scala.xml.XML
import org.apache.commons.dbcp.BasicDataSource
import org.apache.log4j.Logger.getLogger
import org.apache.log4j.PropertyConfigurator
import com.google.inject.AbstractModule
import com.google.inject.Guice
import com.google.inject.Injector
import com.google.inject.Provides
import com.google.inject.name.Names
import com.jkbff.ao.tyrlib.chat.MMDBParser
import javax.sql.DataSource
import com.google.inject.Singleton
import pro.savant.circumflex.core.Circumflex

class MyModule(config: Config) extends AbstractModule {
	//private val entityManageCache = new ThreadLocal[EntityManager];

	override def configure() {
		bindConstant().annotatedWith(Names.named("name")).to(config.logins(0).character)
		bindConstant().annotatedWith(Names.named("serverNum")).to(config.server.id)
		bindConstant().annotatedWith(Names.named("superAdmin")).to(config.superAdmin)
		bind(classOf[Tyrbot]).to(classOf[TyrbotImpl])
	}

	/*	
	@Provides @Singleton
	def provideEntityManagerFactory() = Persistence.createEntityManagerFactory("tyrbot")

	@Provides
	def provideEntityManager(entityManagerFactory: EntityManagerFactory): EntityManager = {
	    if (entityManageCache.get() == null) {
	    	entityManageCache.set(entityManagerFactory.createEntityManager())
	    }
	    entityManageCache.get()
	}
	*/

	@Provides
	def provideAOConnection(): AOSimpleConnection = {
		new AOSimpleConnection(config.logins)
	}

	@Provides
	def provideDataSource(): DataSource = {
		val ds = new BasicDataSource()
		ds.setDriverClassName(config.dbDriverClass)
		ds.setUrl(config.dbConnectionString)
		ds.setUsername(config.dbUsername)
		ds.setPassword(config.dbPassword)
		ds
	}
}

object Bootstrap {
	private val log = getLogger(this.getClass())
	var shutdown = false
	var injector: Injector = _

	def main(args: Array[String]) {
		Bootstrap.run()
	}

	def run(): Unit = {
		while (!shutdown) {
			// initialize the log4j component
			PropertyConfigurator.configure("log4j.xml")

			// load the properties file for the bot
			val config = new Config(XML.load("config.xml"))

			// tell the lib where to find the text.mdb file
			MMDBParser.fileLocation = config.textMDBLocation

			// create bot instance
			injector = Guice.createInjector(new MyModule(config))
			val bot = injector.getInstance(classOf[Tyrbot])

			// configure circumflex
			Circumflex.put("orm.connection.driver", config.dbDriverClass)
			Circumflex.put("orm.connection.url", config.dbConnectionString)
			Circumflex.put("orm.connection.username", config.dbUsername)
			Circumflex.put("orm.connection.password", config.dbPassword)

			bot.start
			bot.join

			// if shutdown was unintentional, wait 5 seconds before restarting
			if (!bot.shouldStop) {
				Thread.sleep(5000)
			}
		}
	}
}
