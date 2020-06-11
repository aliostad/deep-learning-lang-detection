package com.cbf.descriptive


/**
 * Descriptive
 * User: Fredrik
 * Date: 2009-sep-04
 * Time: 19:57:22
 */

object DescriptiveNew {

  /**
   * Main method
   */
  def main(args:Array[String]) = {

    //Control.resultHandlers = new ConsolPrinter() :: Control.resultHandlers

    //executeOperation(args(0), args.subArray(1, args.length))
  }

  /**
   * Executes an operation that is requested
   */
  private def executeOperation(operation:String, parameters:Array[String]) {
    // Check what operation that was requested
    operation match {
      case "help" => printUsage
      case "compile" => {
        executeCompile(parameters)
      }
      case "" => {
        // This is normal execution, load all and execute.
        // load all descriptors
        Control.loadDescriptors(callback)
        // load all actions first
        Control.loadActions(callback)
        // load the actions
        Control.compileAll(callback)
        // Execute all
        Control.execute(callback)
      }
    }
  }

  /**
   *  Handle execution of "compile" action
   */
  private def executeCompile(parameters:Array[String]) {
    // Now check if there were any parameters to the compilation
    parameters.length match {
      case 0 => {
        // No parameters, go ahead and just execute
        // load all descriptors
        Control.loadDescriptors(callback)
        // load all actions first
        Control.loadActions(callback)
        // load the actions
        Control.compileAll(callback)
      }
      case 1 => {
        // One parameter, this parameter is the test specification to load
        // load all descriptors
        Control.loadDescriptors(callback)
        // load all actions first
        Control.loadActions(callback)
        // Compile only the one test specification
        Control.compile(parameters(0), callback)
      }
    }
  }

  /**
   *  Prints usage
   */
  private def printUsage {
    println("Usage")
  }

  /**
   * Callback method from ControlCallback
   */
  def callback(message:String) {
    println(message)
  }
}