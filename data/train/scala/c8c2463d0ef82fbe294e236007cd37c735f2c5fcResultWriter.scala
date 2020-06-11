package de.aquanauten.insights

import java.io.{BufferedWriter, File, FileWriter, Writer}

object ResultWriter {

  def writeFile(fileName: String)(writeFn: Writer => Unit): Unit = {
    val file = new File(fileName)
    file.getParentFile.mkdirs()
    val writer = new BufferedWriter(new FileWriter(file))
    try {writeFn(writer)} finally {writer.close()}
  }

  def writeDependencies(packageFile: String, packageDependencies: Dependencies): Unit = {
    // write dot file
    writeFile(packageFile + ".dot") (_.write(Rendering.render(packageDependencies)(DotRendering.DependencyRendering)))
    // write plantuml file
    writeFile(packageFile + ".puml") (_.write(Rendering.render(packageDependencies)(PlantUMLRendering.DependencyRendering)))
    // write json file
    writeFile(packageFile + ".json") (_.write(Rendering.render(packageDependencies)(JsonRendering.DependencyRendering)))
  }

  def writeClasses(targetDir: String, classFile: String, compileUnit: CompileUnit): Unit = {
    // global view
    writeFile(s"$targetDir/$classFile.json") { _.write(JsonRendering.render(compileUnit)) }
    writeFile(s"$targetDir/$classFile.puml") { _.write(PlantUMLRendering.render(compileUnit)) }

    // per package view
    compileUnit.classes.groupBy(_.packageName).foreach { case (packageName, classes) =>
      writeFile(s"$targetDir/package/puml/$packageName.puml")(_.write(PlantUMLRendering.render(CompileUnit(classes))))
    }
  }
}
