package no.officenet.example.rpm.web.context

import org.springframework.web.context.request.RequestContextListener
import javax.servlet.ServletRequestEvent
import org.springframework.context.i18n.LocaleContextHolder

/**
 * This class delegates to Spring's but resets the LocaleContextHolder as we want to manage our own locale
 */
class RpmRequestContextListener extends RequestContextListener {

	override def requestInitialized(requestEvent: ServletRequestEvent) {
		super.requestInitialized(requestEvent)
		LocaleContextHolder.resetLocaleContext()
	}
}
