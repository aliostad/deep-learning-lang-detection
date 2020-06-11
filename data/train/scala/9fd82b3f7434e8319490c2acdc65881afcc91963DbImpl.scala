package models

object DbImpl {
  type HaveIdAndName = {
    def id: Int
    def name: String
  }
}

trait DbImpl[T <: DbImpl.HaveIdAndName with Product] {

  def createDefaultList: List[T]

  protected var list: List[T] = createDefaultList

  def findByName(name: String) = list.find(_.name == name)

  def exists(name: String) = list.exists(_.name == name)

  def find(id: Int) = list.filter(_.id == id).headOption

  def update(id: Int)(t: T) = {
    def replace(updated: T) = (old: T) => if (updated.id == old.id) updated else old
    list = list.map(replace(t))
    t
  }

  def delete(id: Int) = {
    list = list.filter(_.id != id)
  }

  def nextId = list.size + 1

  def add(t: T) = {
    list = t :: list
    t
  }
  
  def all = list


}
