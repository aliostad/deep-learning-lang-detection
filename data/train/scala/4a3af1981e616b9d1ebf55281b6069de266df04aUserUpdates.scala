/**
 * **********************************************************************************************
 * Copyright (c) 2011 Fabian Steeg. All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0 which accompanies this
 * distribution, and is available at http://www.eclipse.org/legal/epl-v10.html
 * <p/>
 * Contributors: Fabian Steeg - initial API and implementation
 * *********************************************************************************************
 */
package de.uni_koeln.ub.drc.util
import com.quui.sinist.XmlDb
import de.uni_koeln.ub.drc.data.User

/**
 * Update user data.
 * @author Fabian Steeg
 */
object UserUpdates {

  val fromDb = XmlDb("bob.spinfo.uni-koeln.de", 8080)
  val toDb = XmlDb("bob.spinfo.uni-koeln.de", 7777)
  val col = "drc/users"

  def main(args: Array[String]): Unit = {
    for (fromId <- fromDb.getIds(col).get) {
      if (fromId.endsWith(".xml")) {
        val fromXml = fromDb.getXml(col, fromId).get(0)
        val oldUser = User.fromXml(fromXml)
        val newUser = User(
          oldUser.id,
          oldUser.name,
          oldUser.region,
          oldUser.pass,
          oldUser.collection,
          XmlDb("bob.spinfo.uni-koeln.de", 8080)) // change this
        newUser.edits = oldUser.edits
        newUser.upvotes = oldUser.upvotes
        newUser.upvoted = oldUser.upvoted
        newUser.downvotes = oldUser.downvotes
        newUser.downvoted = oldUser.downvoted
        newUser.latestPage = oldUser.latestPage
        newUser.latestWord = oldUser.latestWord
        toDb.putXml(newUser.toXml, col, fromId)
      }
      println("Processed: " + fromId)
    }
  }

}
