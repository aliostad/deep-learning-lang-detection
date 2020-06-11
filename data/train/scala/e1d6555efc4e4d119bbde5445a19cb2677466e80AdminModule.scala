//     Project: angulate2-examples
//      Module:
// Description:

// Copyright (c) 2017. Distributed under the MIT License (see included LICENSE file).
package routing.admin

import angulate2.common.CommonModule
import angulate2.std._
import routing.AuthGuard

@NgModule(
  imports = @@[CommonModule,AdminRoutingModule],
  declarations = @@[AdminComponent,AdminDashboardComponent,ManageCrisesComponent,ManageHeroesComponent]
)
class AdminModule {

}

@Routes(
  root = false,
  Route(
    path = "admin", component = %%[AdminComponent],
    canActivate = @@[AuthGuard],
    children = @@@(
      Route(path = "",
        canActivateChild = @@[AuthGuard],
        children = @@@(
          Route(path = "crises", component = %%[ManageCrisesComponent]),
          Route(path = "heroes", component = %%[ManageHeroesComponent]),
          Route(path = "", component = %%[AdminDashboardComponent])
        )))
  )
)
class AdminRoutingModule
