package eu.sbradl.liftedcontent.core.snippet

import net.liftweb.util.Helpers._
import eu.sbradl.liftedcontent.core.lib.RequestHelpers
import eu.sbradl.liftedcontent.core.lib.SiteMetaDataHelpers

class ManageMetaTags {

  def render = {
    "data-lift-id=url *" #> RequestHelpers.allPaths(withAdditionalPaths = true).map {
      url => {
        "data-lift-id=title *" #> url &
        "data-lift-id=tags *" #> SiteMetaDataHelpers.metadataFor(url).map {
          metadata => {
            "data-lift-id=tagName *" #> metadata.name.is.toString &
            "data-lift-id=tagContent *" #> metadata.content
          }
        }
      }
    }
  }
  
}