package horse.programtext

import java.io.PrintStream
import scala.collection.mutable.{ArrayBuffer, Buffer}

import horse.core.program.Interpreter.Program
import horse.programtext.editor.Action
import horse.serialization

object Protocol {
    def log(a: Action) {
        actions += a
    }

    def dump(out: PrintStream) {
        serialization.dumpProgram(prog, out)
        out.println()
        for (a <- actions) {
            out.println(a)
        }
    }

    def setProgram(prog: Program) {
        this.prog = prog
        actions.clear()
    }
    
    private[this] val actions: Buffer[Action] = new ArrayBuffer
    
    private[this] var prog: Program = ProgramText.program
}