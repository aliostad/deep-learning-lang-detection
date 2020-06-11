package edu.unl.biofinity.site.user.service

import net.liftweb._
import net.liftweb.common._
import net.liftweb.http._
import net.liftweb.http.js._
import net.liftweb.http.js.JE._
import net.liftweb.http.js.JsCmds._
import net.liftweb.http.S._
import net.liftweb.mapper._
import net.liftweb.util._
import net.liftweb.util.Helpers._

import scala.xml._

trait UserService {
	def name: String
	def description: String
	def activeIcon: String
	def inactiveIcon: String
	def largeIcon: String
	def actions: String
	def enabled: Boolean
	def enableLogic: JsCmd
	def manageLogic: JsCmd
}