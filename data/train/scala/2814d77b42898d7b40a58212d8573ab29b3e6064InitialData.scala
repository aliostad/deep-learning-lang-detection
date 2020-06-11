/*
Copyright (c) 2013, Wellcome Trust Sanger Institute

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.

    * Neither the name of the Wellcome Trust Sanger Institute nor the 
      names of other contributors may be used to endorse or promote 
      products derived from this software without specific prior written 
      permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package models

import play.api._
import models._
import models.dao._
import rules.MetaRoles
import java.sql.{ Date => SQLDate }

import play.api.Play.current
import play.api.db.slick.DB
import play.api.db.slick.Config.driver.profile.simple._

object InitialData {

  val set_global_role = MetaRoles.set_global_role.instantiate(Map.empty[String, String]).get

  val initialParameterTypes = Seq(
    ParameterType("project", Some("Project role")))

  val initialRoleTypes = Seq(
    MetaRoles.set_global_role,
    MetaRoles.create_project,
    MetaRoles.delegate,
    MetaRoles.grant_project_role,
    RoleType("manage_project_users", Some("Can manage users for this project."), initialParameterTypes),
    RoleType("manage_project_datasets", Some("Can manage datasets for this project."), initialParameterTypes),
    RoleType("manage_project_resources", Some("Can manage resources for this project."), initialParameterTypes))

  val initialUsers = Seq(
    UserDO(1L, "nc6@sanger.ac.uk", "Nicholas Clarke"))

  val initialUserRoles = Seq(
    "nc6@sanger.ac.uk" -> set_global_role)

  def insert() = DB.withSession { implicit session =>
    if (ParameterTypes.length.run == 0 && RoleTypes.length.run == 0) {
      initialRoleTypes.foreach(RoleType.insert)
    }

    if (Users.length.run == 0) {
      initialUsers.foreach(Users.insert)
      initialUserRoles.foreach(Function.tupled(User.addRole))
    }
  }

}