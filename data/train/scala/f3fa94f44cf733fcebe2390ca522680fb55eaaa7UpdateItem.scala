package services

import module.{Inventory, Item}
import scala.concurrent.Future

class UpdateItem {

  class UpdateItem {

    def updateItemCount(inventory: Inventory, item: Item, update : Int, f:(Int,Int)=>Int) :Future[Option[Item]] = Future {

      val itemWithOldCount = inventory.items.filter(_.itemType == item)(0)

      if (update == 0) {
        val itemNewCount = itemWithOldCount.copy(noOfItems = f(itemWithOldCount.noOfItems, update))
        Some(itemNewCount)

      }
      else None
    }

  }

}
