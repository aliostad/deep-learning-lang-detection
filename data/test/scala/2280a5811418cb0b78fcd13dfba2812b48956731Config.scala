package harmonic.compiler

import java.io.File
import java.io.PrintStream
import scala.collection.mutable.ListBuffer
import harmonic.Harmonize.version
import Util._

class Config
{
    val sourceExt = ".harm"
    val classExt = ".class"
    var sourcePaths = List(new File("."))
    var classPaths = List(new File("."))
    val inputFiles = new ListBuffer[File]()
    var outputDir = new File(".")
    var dumpParsedTrees = false
    var dumpResolvedTrees = false
    var dumpLoweredTrees = false
    var dumpBytecode = false
    var checkBytecode = false
    var ignoreErrors = false
    var useReflection = true
    var localize = false
    var emitDebugInfo = true
    var joinIfMore = Integer.MAX_VALUE
    var joinIfLess = 0
    var debugPort = 0
    
    private[this] def usage(err: PrintStream) {
        err.printf("The Harmonic Language, version %s\n", version)
        err.printf("\n")
        err.printf("Usage: harmonize compile [options] sourcefiles\n")
        err.printf("\n")
        err.printf("Options:\n")
        err.printf("  -d <dir>\n")
        err.printf("  -classpath <paths>\n")
        err.printf("  -sourcepath <paths>\n")
        err.printf("  --no-reflection\n")
        err.printf("  --no-localize\n")
        err.printf("  --no-debug-info\n")
        err.printf("\n")
        err.printf("Debugging options:\n")
        err.printf("  --debug-port <port>\n")
        err.printf("  --dump-parsed-trees\n")
        err.printf("  --dump-resolved-trees\n")
        err.printf("  --dump-lowered-trees\n")
        err.printf("  --dump-bytecode\n")
        err.printf("  --check-bytecode\n")
        err.printf("  --join-if-more <error count>\n")
        err.printf("  --join-if-less <error count>\n")
        err.printf("  --ignore-errors\n")
    }
    
    private[this] def dirs(paths: String) = {
        paths.split(":").map(s => new File(s)).toList
    }
    
    private[this] def relativeFiles(paths: List[File], ext: String)(name: Name.Class) = {
        val baseName = name.relPath
        paths.flatMap { path =>
            val file = new File(path, baseName + ext)
            if(file.exists) Some(file)
            else None
        }
    }
    
    def sourceFiles(name: Name.Class) = relativeFiles(sourcePaths, sourceExt)(name)
    def classFiles(name: Name.Class) = relativeFiles(classPaths, classExt)(name)
    
    def reflectiveClasses(name: Name.Qual) = {
        if(!useReflection) None
        else {
            try {
                Some(Class.forName(name.toString))
            } catch {
                case _: java.lang.ClassNotFoundException => None
            }
        }
    }
    
    def loadFrom(args: Array[String]): Boolean = {
        var i = 0
        try {
            if(args.isEmpty)
                usage(System.err)
            while(i < args.length) {
                if(args(i) == "-classpath" || args(i) == "-cp") {
                    classPaths = dirs(args(i+1))
                    i += 2
                } else if(args(i) == "-sourcepath") {
                    sourcePaths = dirs(args(i+1))
                    i += 2
                } else if(args(i) == "-d") {
                    outputDir = new File(args(i+1))
                    i += 2
                } else if(args(i) == "--debug-port") {
                    debugPort = Integer.parseInt(args(i+1))
                    i += 2
                } else if(args(i) == "--dump-parsed-trees") {
                    dumpParsedTrees = true
                    i += 1
                } else if(args(i) == "--dump-resolved-trees") {
                    dumpResolvedTrees = true
                    i += 1
                } else if(args(i) == "--dump-lowered-trees") {
                    dumpLoweredTrees = true
                    i += 1
                } else if(args(i) == "--dump-bytecode") {
                    dumpBytecode = true
                    i += 1
                } else if(args(i) == "--check-bytecode") {
                    checkBytecode = true
                    i += 1
                } else if(args(i) == "--ignore-errors") {
                    ignoreErrors = true
                    i += 1
                } else if(args(i) == "--join-if-more") {
                    joinIfMore = Integer.parseInt(args(i+1))
                    i += 2
                } else if(args(i) == "--join-if-less") {
                    joinIfLess = Integer.parseInt(args(i+1))
                    i += 2
                } else if(args(i) == "--no-reflection") {
                    useReflection = false
                    i += 1
                } else if(args(i) == "--no-localize") {
                    localize = false
                    i += 1
                } else if(args(i) == "--no-debug-info") {
                    emitDebugInfo = false
                    i += 1
                } else if(args(i) startsWith "-") {
                    usage(System.err)
                    System.err.printf("\nUnrecognized option '%s'\n", args(i))
                    return false
                } else {
                    inputFiles += new File(args(i))
                    i += 1
                }
            }
            return true         
        } catch {
            case _: java.lang.ArrayIndexOutOfBoundsException =>
                usage(System.err)
        }
        return false
    }
}