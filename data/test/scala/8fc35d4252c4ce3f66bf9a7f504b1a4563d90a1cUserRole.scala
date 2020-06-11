/*
 * Copyright (C) 2016 HAT Data Exchange Ltd - All Rights Reserved
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 * Written by Andrius Aucinas <andrius.aucinas@hatdex.org>, 10 2016
 */

package org.hatdex.commonPlay.models.auth.roles

import java.util.UUID

import anorm.SqlParser._
import anorm.{ RowParser, ~ }

import scala.util.{ Failure, Success, Try }

sealed abstract class UserRole(roleTitle: String) {
  def title: String = roleTitle

  def name: String = this.toString.replaceAll("\\(.*\\)", "")

  def extra: Option[String] = None
}

object UserRole {
  def userRoleParser: RowParser[(UserRole, Boolean)] = {
    get[String]("user_role.role") ~
      get[Option[String]]("user_role.extra") ~
      get[Boolean]("user_role.approved") map {
        case role ~ extra ~ approved => userRoleDeserialize(role, extra, approved)
      }
  }

  //noinspection ScalaStyle
  def userRoleDeserialize(userRole: String, roleExtra: Option[String], approved: Boolean): (UserRole, Boolean) = {
    (userRole, roleExtra) match {
      case (role, None) =>
        role match {
          case "Master"           => (Master(), approved)
          case "ViewDataStats"    => (ViewDataStats(), approved)
          case "HatUser"          => (HatUser(), approved)
          case "ViewDataPlugs"    => (ViewDataPlugs(), approved)
          case "CreateDataPlugs"  => (CreateDataPlugs(), approved)
          case "ManageDataPlugs"  => (ManageDataPlugs(), approved)
          case "CanSignupChat"    => (CanSignupChat(), approved)
          case "CanChat"          => (CanChat(), approved)
          case "GetDataOffers"    => (GetDataOffers(), approved)
          case "CreateDataOffers" => (CreateDataOffers(), approved)
          case "ManageDataOffers" => (ManageDataOffers(), approved)
          case _                  => (UnknownRole(), approved)
        }
      case (role, Some(extra)) =>
        val extraId = Try(UUID.fromString(extra))
        (role, extraId) match {
          case ("OwnsDataPlug", Success(id))  => (OwnsDataplug(id), approved)
          case ("OwnsHat", Failure(e))        => (OwnsHat(extra), approved)
          case ("OwnsDataOffer", Success(id)) => (OwnsDataOffer(id), approved)
          case _                              => (UnknownRole(), approved)
        }
    }
  }
}

// Generic
case class Master() extends UserRole("master")

case class ViewDataStats() extends UserRole("View Data Statistics")

case class UnknownRole() extends UserRole("Unknown")

// HAT
case class OwnsHat(hat: String) extends UserRole(s"Owns HAT $hat") {
  override def extra: Option[String] = Some(hat)
}

case class HatUser() extends UserRole("Has a HAT")

// Data Plugs
case class ViewDataPlugs() extends UserRole("View Data Plugs")

case class CreateDataPlugs() extends UserRole("Create Data Plugs")

case class OwnsDataplug(id: UUID) extends UserRole(s"Owns Dataplug $id") {
  override def extra: Option[String] = Some(id.toString)
}

case class ManageDataPlugs() extends UserRole(s"Manage Dataplugs")

// Discussions
case class CanSignupChat() extends UserRole("Signup for Chat")

case class CanChat() extends UserRole("Chat")

// Offers
case class GetDataOffers() extends UserRole("Get Data Offers")

case class CreateDataOffers() extends UserRole("Create Data Offers")

case class ManageDataOffers() extends UserRole("Manage Data Offers")

case class OwnsDataOffer(id: UUID) extends UserRole(s"Owns Data Offer $id") {
  override def extra: Option[String] = Some(id.toString)
}