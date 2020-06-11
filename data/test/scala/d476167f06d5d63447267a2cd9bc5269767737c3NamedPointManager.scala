package tuner

class NamedPointManager(defaultPrefix:String) {
  
  var _points:Map[String,List[(String,Float)]] = Map()

  def add(name:String, position:List[(String,Float)]) : Unit = {
    _points += (name -> position)
  }

  def add(position:List[(String,Float)]) : Unit = {
    // First make sure this point isn't stored yet
    if(!_points.values.exists(x => x == position)) {
      add(defaultPrefix + " " + _points.size, position)
    }
  }

  def rename(oldName:String, newName:String) = {
    val pt = _points(oldName)
    _points -= oldName
    _points += (newName -> pt)
  }

  def clear = _points = Map()

  def point(name:String) = _points(name)

  def names : List[String] = _points.keys.toList.sorted

  def size = _points.size
}

