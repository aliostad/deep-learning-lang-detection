package org.kineticcafe

class NewSet(initial_value: Array[Any]) {
  var collection = uniquify(initial_value)

  def this() = this(Array[Any]())

  def length: Int = {
    collection.length
  }

  def add(value: Any): NewSet = {
    if(!collection.contains(value)) {
      collection = collection :+ value
    }

    this
  }

  def show: Array[Any] = {
    collection
  }

  def drop(value: Any): NewSet = {
    collection = for(old <- collection if old != value) yield old

    this
  }

  private def uniquify(array: Array[Any]) = {
    var newarray = Array[Any]()

    for(old <- array) {
      if(!newarray.contains(old)) {
        newarray = newarray :+ old
      }
    }

    newarray
  }
}
