import java.io.File

class FileRenamer {

  // usage: file-renamer root-dir old-extension new-extension
  def main(args: Array[String]): Unit = {
    rename(args(0), args(1), args(2))
  }

  def rename(rootDir: File, oldExtension:String, newExtension: String) = {
    for (f <- rootDir.listFiles) {
      if (f.isDirectory)
	rename(f, oldExtension, newExtension)
      else if (f.getName.endsWith("." + oldExtension)) {
	val newName = f.getName.replace("." + oldExtension, "." + newExtension)
	f.renameTo(new File(rootDir, newName))
      }
    }
  }
}
