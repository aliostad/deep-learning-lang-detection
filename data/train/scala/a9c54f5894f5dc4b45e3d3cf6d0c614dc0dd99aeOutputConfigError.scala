package com.github.madoc.create_sbt_project.config.validation

import com.github.madoc.create_sbt_project.config.validation.ConfigError.ErrorLocation.ConfigProperty._
import com.github.madoc.create_sbt_project.config.validation.ConfigError.ErrorLocation._
import com.github.madoc.create_sbt_project.config.validation.ConfigError.ErrorNature._
import com.github.madoc.create_sbt_project.config.validation.ConfigError.{ErrorLocation, SomethingToDefine}
import com.github.madoc.create_sbt_project.config.{LibraryRefConfig, PluginRefConfig}
import com.github.madoc.create_sbt_project.io.{Output, Write}

object OutputConfigError extends Output[ConfigError] {
  def apply(error:ConfigError)(write:Write) = error nature match {
    case DuplicateJavaOptionContext(context) ⇒
      write("Duplicate Java option context (")
      var firstItem = true
      context foreach {str ⇒ if(firstItem) firstItem=false else write(", "); write.inQuotes(_ stringEscaped str)}
      write(")")
      finishSentenceWithLocation(error location, bindingWord="in")(write)
    case ElementIsEmpty ⇒
      write("Empty"); finishSentenceWithLocation(error location)(write)
    case WhitespaceAfter ⇒
      write("Whitespace"); finishSentenceWithLocation(error location, bindingWord="after")(write)
    case WhitespaceBefore ⇒
      write("Whitespace"); finishSentenceWithLocation(error location, bindingWord="before")(write)
    case MissingDefinition(what, ref) ⇒
      write("Missing definition for ")(what match {
        case SomethingToDefine.Library ⇒ "library"
        case SomethingToDefine.Plugin ⇒ "plugin"
        case SomethingToDefine.Resolver ⇒ "resolver"
      })(" ") inQuotes {_ stringEscaped ref}
      finishSentenceWithLocation(error location, bindingWord="in")(write)
    case MoreThanOneProjectDirectorySpeficied ⇒
      write("More than one project directory specified")
      finishSentenceWithLocation(error location, bindingWord="in")(write)
    case NeitherNameNorDirectoryIsSet ⇒
      write("Neither project name nor project directory is set, but one of the two must be given")
      finishSentenceWithLocation(error location, bindingWord="in")(write)
    case UnrecognizedCommandLineOption ⇒
      write("Unrecognized option")
      finishSentenceWithLocation(error location, bindingWord=":")(write)
  }

  private def finishSentenceWithLocation(location:ErrorLocation, bindingWord:String=null)(write:Write):Unit =
    location match {
      case CommandLineArgument(arg) ⇒
        writeBindingWord(bindingWord)(write)
        write(arg)
      case ElementOf(element, ofLocation) ⇒
        writeBindingWord(bindingWord)(write)
        write(element name)
        finishSentenceWithLocation(ofLocation, bindingWord="of")(write)
      case LibraryRefConfigLocation(lib) ⇒
        writeBindingWord(bindingWord)(write)
        write("library definition: ")(lib)
      case PluginRefConfigLocation(plugin) ⇒
        writeBindingWord(bindingWord)(write)
        write("plugin definition: ")(plugin)
      case configProperty:ConfigProperty ⇒
        writeBindingWord(bindingWord)(write)
        describeConfigPropertyAsLocation(configProperty)(write)
        write(".")
      case ReferredBy(origin) ⇒ write(", as referred to"); finishSentenceWithLocation(origin, "in")(write)
      case Unspecific ⇒ write(".")
    }

  private def writeBindingWord(bindingWord:String)(write:Write):Unit = {
    Option(bindingWord) foreach {word ⇒
      if(!(word startsWith ":")) write(" ")
      write(word)
    }
    write(" ")
  }

  private def describeConfigPropertyAsLocation(configProperty:ConfigProperty)(write:Write):Unit = configProperty match {
    case ProjectDirectory ⇒ write("project directory")
    case ProjectName ⇒ write("project name")
    case ProjectOrganization ⇒ write("project organization")
    case ProjectVersion ⇒ write("project version")
    case SBTVersion ⇒ write("SBT version")
    case ScalaVersion ⇒ write("Scala version")
  }

  val sequence:Output[Seq[ConfigError]] = new Output[Seq[ConfigError]] {
    def apply(the:Seq[ConfigError])(write:Write) = the.foreach(write(_) lineBreak())
  }

  private implicit val libraryRefConfigOutput:Output[LibraryRefConfig] = new Output[LibraryRefConfig] {
    def apply(the:LibraryRefConfig)(write:Write) {
      write inQuotes {_ stringEscaped (the group)}
      if(!(the.addScalaVersion contains false)) write(" %% ") else write(" % ")
      write inQuotes {_ stringEscaped (the artifact)}
      write(" % ") inQuotes {_ stringEscaped (the version)}
      (the configuration) foreach {configuration ⇒ write(" % ") inQuotes {_ stringEscaped configuration}}
      if(the.withSources contains true) write(" withSources()")
    }
  }

  private implicit val pluginRefConfigOutput:Output[PluginRefConfig] = new Output[PluginRefConfig] {
    def apply(the:PluginRefConfig)(write:Write) {
      write inQuotes {_ stringEscaped (the group)}
      write(" % ")
      write inQuotes {_ stringEscaped (the artifact)}
      write(" % ")
      write inQuotes {_ stringEscaped (the version)}
    }
  }
}
