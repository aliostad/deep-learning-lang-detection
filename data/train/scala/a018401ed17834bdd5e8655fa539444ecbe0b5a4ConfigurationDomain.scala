package apiclient.v2.domain.configuration

import javax.inject.Inject

import apiclient.v2.domain.configuration.clientsession.ClientSessionDomain
import apiclient.v2.domain.configuration.directoryconfiguration.DirectoryConfigurationDomain
import apiclient.v2.domain.configuration.googleconfiguration.{GoogleAnalyticsConfigurationDomain, GoogleRecaptchaConfigurationDomain}
import apiclient.v2.domain.configuration.highlightsconfiguration.HighlightConfigurationDomain
import apiclient.v2.domain.configuration.lazyloadconfiguration.LazyLoadConfigurationDomain
import apiclient.v2.domain.configuration.opacobjectconfiguration.OpacObjectConfigurationDomain
import apiclient.v2.domain.configuration.opacpersonconfiguration.OpacPersonConfigurationDomain
import apiclient.v2.domain.configuration.roleconfiguration.RoleConfigurationDomain
import apiclient.v2.domain.configuration.searchconfiguration.SearchConfigurationDomain
import apiclient.v2.domain.view.ViewDefinitionsCollectionDomain
import constants.OpacConstants
import play.api.libs.json.Json

import scala.concurrent.Future

case class ConfigurationDomain(
  googleAnalyticsConfiguration:GoogleAnalyticsConfigurationDomain,
  googleRecaptchaConfiguration: GoogleRecaptchaConfigurationDomain,
  viewDefinitionsCollection: ViewDefinitionsCollectionDomain,
  highlightConfiguration:HighlightConfigurationDomain,
  opacObjectConfiguration: OpacObjectConfigurationDomain,
  lazyLoadConfiguration : LazyLoadConfigurationDomain,
  directoryConfiguration : DirectoryConfigurationDomain,
  roleConfiguration : RoleConfigurationDomain,
  searchConfiguration : SearchConfigurationDomain,
  clientSession: ClientSessionDomain,
  opacPersonConfiguration:OpacPersonConfigurationDomain){

    /**
      * Get the default view
      * @return
      */
    def getDefaultView(): String = {
        viewDefinitionsCollection.defaultViewName
    }

    /**
      * Get the default view page size
      * @return
      */
    def getDefaultViewPageSize(): Int = {
        val defaultView = viewDefinitionsCollection.defaultViewName
        viewDefinitionsCollection.viewDefinitions.filter(_.viewName.equals(defaultView)).head.pageSize
    }

    /**
      * Get the default view page size for directory
      * @return
      */
    def getDefaultDirectoryViewPageSize(): Int = {
        val defaultView = viewDefinitionsCollection.defaultViewName
        val defaultDirectoryPageSize = defaultView match {
            case OpacConstants.LIST_VIEW => directoryConfiguration.directoryLimitConfiguration.directoryListLimit
            case OpacConstants.LABEL_VIEW => directoryConfiguration.directoryLimitConfiguration.directoryLabelLimit
            case _ => directoryConfiguration.directoryLimitConfiguration.directoryLightboxLimit
        }
        defaultDirectoryPageSize
    }

    /**
      * Get the default view limits
      * @return
      */
    def getDefaultViewLimits() :(Int, Int, Int) = {

        val listViewLimit = getViewDefinitionPageSize(OpacConstants.LIST_VIEW)
        val lightboxViewLimit = getViewDefinitionPageSize(OpacConstants.LIGHTBOX_VIEW)
        val labelViewLimit = getViewDefinitionPageSize(OpacConstants.LABEL_VIEW)

        (listViewLimit, lightboxViewLimit, labelViewLimit)
    }

    /**
      * Get the view page size from cache or from configurationDomain
      *
      * @param viewName
      * @return
      */
    def getViewDefinitionPageSize(viewName: String): Int = {
        val defaultPageSize = viewDefinitionsCollection.viewDefinitions.filter(viewDefinitionDomain => viewDefinitionDomain.viewName == viewName).head.pageSize
        defaultPageSize
    }

    /**
      * Use object lazy load limit only if it is less than the requested limit and greater than zero
      * @param requestedLimit
      * @return
      */
    def getObjectLazyLoadLabelLimit(requestedLimit: Int):Int = {

        //Limit would always be the lazy loading limit if lazy loading is enabled
        val lazyLimit = if (lazyLoadConfiguration.objectLazyLoadConfiguration.objectLazyLoadEnabled
          && lazyLoadConfiguration.objectLazyLoadConfiguration.objectLabelLazyLoadLimit > 0
          && lazyLoadConfiguration.objectLazyLoadConfiguration.objectLabelLazyLoadLimit <= requestedLimit){

            lazyLoadConfiguration.objectLazyLoadConfiguration.objectLabelLazyLoadLimit
        }else {
            requestedLimit
        }

        lazyLimit
    }

    /**
      * Use object lazy load limit only if it is less than the requested limit and greater than zero
      * @param requestedLimit
      * @return
      */
    def getObjectLazyLoadLightboxLimit(requestedLimit: Int):Int = {

        //Limit would always be the lazy loading limit if lazy loading is enabled
        val lazyLimit = if (lazyLoadConfiguration.objectLazyLoadConfiguration.objectLazyLoadEnabled
          && lazyLoadConfiguration.objectLazyLoadConfiguration.objectLightboxLazyLoadLimit > 0
          && lazyLoadConfiguration.objectLazyLoadConfiguration.objectLightboxLazyLoadLimit <= requestedLimit) {

            lazyLoadConfiguration.objectLazyLoadConfiguration.objectLightboxLazyLoadLimit
        } else {
            requestedLimit
        }

        lazyLimit
    }

    /**
      * Use object lazy load limit only if it is less than the requested limit and greater than zero
      * @param requestedLimit
      * @return
      */
    def getObjectLazyLoadListLimit(requestedLimit: Int):Int = {

        //Limit would always be the lazy loading limit if lazy loading is enabled
        val lazyLimit = if (lazyLoadConfiguration.objectLazyLoadConfiguration.objectLazyLoadEnabled
          && lazyLoadConfiguration.objectLazyLoadConfiguration.objectListLazyLoadLimit > 0
          && lazyLoadConfiguration.objectLazyLoadConfiguration.objectListLazyLoadLimit <= requestedLimit) {

            lazyLoadConfiguration.objectLazyLoadConfiguration.objectListLazyLoadLimit
        } else {
            requestedLimit
        }

        lazyLimit
    }

    /**
      * Use person lazy load limit only if it is less than the requested limit and greater than zero
      * @param requestedLimit
      * @return
      */
    def getPersonLazyLoadLightboxLimit(requestedLimit: Int):Int = {

        //Limit would always be the lazy loading limit if lazy loading is enabled
        val lazyLimit = if (lazyLoadConfiguration.personLazyLoadConfiguration.personLazyLoadEnabled
          && lazyLoadConfiguration.personLazyLoadConfiguration.personLightboxLazyLoadLimit > 0
          && lazyLoadConfiguration.personLazyLoadConfiguration.personLightboxLazyLoadLimit <= requestedLimit){

            lazyLoadConfiguration.personLazyLoadConfiguration.personLightboxLazyLoadLimit
        }else {
            requestedLimit
        }

        lazyLimit
    }

    /**
      * Use person lazy load limit only if it is less than the requested limit and greater than zero
      * @param requestedLimit
      * @return
      */
    def getPersonLazyLoadLabelLimit(requestedLimit: Int):Int = {

        //Limit would always be the lazy loading limit if lazy loading is enabled
        val lazyLimit = if (lazyLoadConfiguration.personLazyLoadConfiguration.personLazyLoadEnabled
          && lazyLoadConfiguration.personLazyLoadConfiguration.personLabelLazyLoadLimit > 0
          && lazyLoadConfiguration.personLazyLoadConfiguration.personLabelLazyLoadLimit <= requestedLimit){

            lazyLoadConfiguration.personLazyLoadConfiguration.personLabelLazyLoadLimit
        }else {
            requestedLimit
        }

        lazyLimit
    }

    /**
      * Use person lazy load limit only if it is less than the requested limit and greater than zero
      * @param requestedLimit
      * @return
      */
    def getPersonLazyLoadListLimit(requestedLimit: Int):Int = {

        //Limit would always be the lazy loading limit if lazy loading is enabled
        val lazyLimit = if (lazyLoadConfiguration.personLazyLoadConfiguration.personLazyLoadEnabled
          && lazyLoadConfiguration.personLazyLoadConfiguration.personListLazyLoadLimit > 0
          && lazyLoadConfiguration.personLazyLoadConfiguration.personListLazyLoadLimit <= requestedLimit){

            lazyLoadConfiguration.personLazyLoadConfiguration.personListLazyLoadLimit
        }else{
            requestedLimit
        }

        lazyLimit
    }
}

object ConfigurationDomain {
    implicit val configurationDomainReads = Json.reads[ConfigurationDomain]
}