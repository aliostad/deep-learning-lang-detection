//     Project: angulate2-examples
//      Module:
// Description:

// Copyright (c) 2017. Distributed under the MIT License (see included LICENSE file).
package routing.admin

import angulate2.std._
import angulate2.ext.tags.simple._
import scalatags.Text.all._
import scalatags.Text.tags2._

@Component(
  template = tpl(
    h3("ADMIN"),
    nav(
      routerLink(url = "./", active = "active", activeOptions = "{ exact: true }")("Dashboard"),
      routerLink(url = "./crises", active = "active")("Manage Crises"),
      routerLink(url = "./heroes", active = "active")("Manage Heroes")
    ),
    routerOutlet
  )
)
class AdminComponent {

}
