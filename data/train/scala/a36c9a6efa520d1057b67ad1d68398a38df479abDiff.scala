import org.demiurgo.operalink.LinkAPIItem
import scala.collection.mutable
import scala.util.parsing.json.{JSON, JSONArray, JSONObject}

package org.demiurgo.operalink {
  class LinkAPIItemDiff(val oldItem: LinkAPIItem,
                        val oldParentId: Option[String]) {
    var newItem: LinkAPIItem = _
    var newParentId: Option[String] = _
    var addedProperties: Set[String] = Set()
    var removedProperties: Set[String] =
      if (oldItem == null) Set() else oldItem.propertyHash.keys.toSet
    var updatedProperties: Set[String] = Set()

    def diffAgainst(updatedItem: LinkAPIItem,
                    updatedParentId: Option[String]): LinkAPIItemDiff = {
      newItem = updatedItem
      newParentId = updatedParentId
      val oldItemProperties = if (oldItem == null) Set[String]() else oldItem.propertyHash.keys.toSet
      val newItemProperties = if (newItem == null) Set[String]() else newItem.propertyHash.keys.toSet
      removedProperties = oldItemProperties.diff(newItemProperties)
      addedProperties   = newItemProperties.diff(oldItemProperties)
      updatedProperties = for (p <- (oldItemProperties & newItemProperties)
                             if oldItem.propertyHash(p) !=
                               newItem.propertyHash(p))
                            yield p
      if (oldParentId != updatedParentId) {
        updatedProperties = updatedProperties ++ List("parent")
      }
      return this
    }

    def diffType: String = {
      if (oldItem == null) {
        return "add"
      } else if (newItem == null) {
        return "remove"
      } else if (removedProperties.size == 0 &&
                 addedProperties.size   == 0 &&
                 updatedProperties.size == 0) {
        return "identical"
      } else {
        return "update"
      }
    }
  }

  class Diff {
    protected def flattenItems(items: Seq[LinkAPIItem],
                               parentId: Option[String] = None): Seq[Pair[LinkAPIItem, Option[String]]] = {
      var returnItems: Seq[Pair[LinkAPIItem, Option[String]]] = Seq()
      for (i <- items) {
        val extraItems = i.itemType match {
          case "bookmark_folder" =>
            flattenItems(i.asInstanceOf[BookmarkFolder].contents, Some(i.id))
          case "note_folder" =>
            flattenItems(i.asInstanceOf[NoteFolder].contents, Some(i.id))
          case _ =>
            Seq()
        }
        returnItems = returnItems ++ Seq(Pair(i, parentId)) ++ extraItems
      }
      return returnItems
    }

    def calculateDiff(srcItems: Seq[LinkAPIItem],
                      dstItems: Seq[LinkAPIItem]): Map[String, LinkAPIItemDiff] = {
      var map: mutable.Map[String, LinkAPIItemDiff] = mutable.Map()
      val realSrcItems = flattenItems(srcItems)
      val realDstItems = flattenItems(dstItems)
      for (pair <- realSrcItems) {
        pair match {
          case (item, parentId) =>
            map(item.id) = new LinkAPIItemDiff(item, parentId)
        }
      }
      for (pair <- realDstItems) {
        pair match {
          case (item, parentId) =>
            if (map.contains(item.id)) {
              map(item.id).diffAgainst(item, parentId)
            } else {
              map(item.id) = new LinkAPIItemDiff(null, None).diffAgainst(item, parentId)
            }
        }
      }
      return map.toMap
    }
  }

  object DiffApp {
    def main(args: Array[String]) {
      if (args.length != 2) {
        println("ERROR: Need two arguments")
        println("SYNTAX: DiffApp <dump1.json> <dump2.json>")
        System.exit(1)
      }

      val jsonString1 = io.Source.fromFile(args(0)).mkString
      val jsonString2 = io.Source.fromFile(args(1)).mkString
      val jsonObject1 = JSON.parseRaw(jsonString1).get.asInstanceOf[JSONArray]
      val jsonObject2 = JSON.parseRaw(jsonString2).get.asInstanceOf[JSONArray]
      val linkItemList1 = for { item <- jsonObject1.list }
                          yield LinkAPIItem.fromJsonObject(item.asInstanceOf[JSONObject])
      val linkItemList2 = for { item <- jsonObject2.list }
                          yield LinkAPIItem.fromJsonObject(item.asInstanceOf[JSONObject])

      val differ = new Diff
      var removed   = mutable.Set[LinkAPIItemDiff]()
      var added     = mutable.Set[LinkAPIItemDiff]()
      var updated   = mutable.Set[LinkAPIItemDiff]()
      var identical = mutable.Set[LinkAPIItemDiff]()
      val diffResult = differ.calculateDiff(linkItemList1, linkItemList2)
      for (i <- diffResult.values) {
        i.diffType match {
          case "add"       => added += i
          case "remove"    => removed += i
          case "update"    => updated += i
          case "identical" => identical += i
        }
      }
      println("There are " + added.size + " added elements")
      println("There are " + removed.size + " removed elements")
      println("There are " + updated.size + " updated elements")
      println("There are " + identical.size + " identical elements")

      println("")
      println("Removed elements")
      println("================")
      for (element <- removed) {
        if (element.oldItem.itemType == "bookmark_separator") {
          println("Bookmark separator")
        } else {
          println("Item '" + element.oldItem.propertyHash("title") + "' (" +
                    element.oldItem.itemType + ")")
        }
        for (attr <- element.removedProperties) {
          println(" * " + attr + ": " + element.oldItem.propertyHash(attr))
        }
      }

      println("")
      println("Updated elements")
      println("================")
      for (element <- updated) {
        if (element.oldItem.itemType == "bookmark_separator") {
          println("Bookmark separator")
        } else {
          println("Item '" + element.oldItem.propertyHash("title") +
                  (if (element.oldItem.propertyHash("title") != element.newItem.propertyHash("title")) ("' (now " + element.newItem.propertyHash("title") + ") (" + element.newItem.itemType + ")") else "'"))
        }
        for (attr <- element.removedProperties) {
          println(" * " + attr + ": " + element.oldItem.propertyHash(attr) +
                         " (removed)")
        }
        for (attr <- element.updatedProperties) {
          if (attr == "parent") {
            println(" * " + attr + ": " + diffResult(element.oldParentId.get).oldItem.propertyHash("title") +
                    " -> " + diffResult(element.newParentId.get).newItem.propertyHash("title"))
          } else {
            println(" * " + attr + ": " + element.oldItem.propertyHash(attr) +
                    " -> " + element.newItem.propertyHash(attr))
          }
        }
        for (attr <- element.addedProperties) {
          println(" * " + attr + ": " + element.newItem.propertyHash(attr) +
                         " (added)")
        }
      }

      println("")
      println("Added elements")
      println("==============")
      for (element <- added) {
        if (element.newItem.itemType == "bookmark_separator") {
          println("Bookmark separator")
        } else {
          println("Item '" + element.newItem.propertyHash("title") + "' (" +
                    element.newItem.itemType + ")")
        }
        for (attr <- element.addedProperties) {
          println(" * " + attr + ": " + element.newItem.propertyHash(attr))
        }
      }
    }
  }
}
