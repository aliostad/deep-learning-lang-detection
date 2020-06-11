package shapiro.netfauxgo.samplecritters

import shapiro.netfauxgo.{World, Patch}

class VolePatch(world: World, x:Int, y:Int) extends Patch(world, x, y) {

  setProperty("vole_population", 8.0)
  setProperty("marten_scent_age", null)
  setProperty("smelliest_marten", null)

  def growVolePopulation = {
    setProperty("vole_population", getProperty("vole_population").asInstanceOf[Double] * 1.01)
  }

  def ageSmellyStuff = {
    val oldScent = getProperty("marten_scent_age")
    if (oldScent != null) {
      val oldScentAsInt = oldScent.asInstanceOf[Int]
      if (oldScentAsInt > 14)
        setProperty("marten_scent_age", null)
      else
        setProperty("marten_scent_age", oldScent.asInstanceOf[Int] + 1)
    }
  }

  override def tick() = {
    growVolePopulation
    ageSmellyStuff
  }
}

