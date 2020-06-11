package scalamelb.intro

object AutoResourceManager {
    type Closeable = { def close() }

    def manage(resources: Closeable*)(block: => Unit) = {
        try {            block
        } finally {
            resources.foreach(resource => {
                try {
                    println("Closing " + resource)
                    resource.close
                } catch {
                    case e: Exception => e.printStackTrace
                }
            })
        }
    }
}

object AutoResourceManagement extends Application {
    import java.io._
    import AutoResourceManager.manage

    def printFrom(reader: BufferedReader): Unit = {
        val line = reader.readLine
        if (line != null) {
            println(line)
            printFrom(reader)
        }
    }

    val firstReader = new BufferedReader(new FileReader("a_file_to_be_read.txt"))
    manage(firstReader) {
        printFrom(firstReader)
    }
}
