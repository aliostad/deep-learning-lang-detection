package scalapipe.gen

import scalapipe._
import scalapipe.opt.ASTOptimizer
import scalapipe.opt.IROptimizer
import java.io.File
import java.io.FileOutputStream
import java.io.PrintStream
import scala.collection.mutable.HashMap

private[scalapipe] class HDLKernelGenerator(
        _kt: InternalKernelType
    ) extends KernelGenerator(_kt) with HDLGenerator {

    private var stateCount      = 0
    private val optimizedAST    = ASTOptimizer(kt).optimize(kt.expression)
    private val ir              = IRNodeEmitter(kt).emit(optimizedAST)
    private val context         = new HDLIRContext(kt)
    protected val graph         = IROptimizer(kt, context).optimize(ir)
    private val moduleEmitter   = new HDLModuleEmitter(kt, graph)

    protected def emitFunctionHDL {
    }

    private def emitHDL: String = {

        val kernelName = "kernel_" + kt.name

        // Write the module header.
        write(s"module $kernelName(")
        enter
        for (i <- kt.inputs.map(_.name)) {
            write(s"input_$i,")
            write(s"avail_$i,")
            write(s"read_$i,")
        }
        for (o <- kt.outputs.map(_.name)) {
            write(s"output_$o,")
            write(s"write_$o,")
            write(s"full_$o,")
        }
        if (kt.ramDepth > 0) {
            write("ram_addr,")
            write("ram_in,")
            write("ram_out,")
            write("ram_mask,")
            write("ram_we,")
            write("ram_re,")
            write("ram_ready,")
        }
        write("running,")
        write("rst,")
        write("clk")
        leave
        write(");")
        enter

        // I/O declarations.
        for (i <- kt.inputs) {
            val name = i.name
            val pts = getTypeString(s"input_$name", i.valueType)
            write(s"input wire $pts;")
            write(s"input wire avail_$name;")
            write(s"output wire read_$name;")
        }
        for (o <- kt.outputs) {
            val name = o.name
            val pts = getTypeString(s"output_$name", o.valueType)
            write(s"output wire $pts;")
            write(s"output wire write_$name;")
            write(s"input wire full_$name;")
        }
        if (kt.ramDepth > 0) {
            val wordBytes = ramWidth / 8;
            write(s"output reg [${ramAddrWidth - 1}:0] ram_addr;")
            write(s"input wire [${ramWidth - 1}:0] ram_in;")
            write(s"output reg [${ramWidth - 1}:0] ram_out;")
            write(s"output reg [${wordBytes - 1}:0] ram_mask;")
            write(s"output reg ram_re;")
            write(s"output reg ram_we;")
            write(s"input wire ram_ready;")
        }
        write("output reg running;")
        write("input wire rst;")
        write("input wire clk;")

        // Configuration options.
        for (c <- kt.configs) {
            val name = c.name
            val value = if (c.value != null) c.value.toString else "0"
            write(s"parameter $name = $value;")
        }

        emitLocals

        // Generate code.
        val nodeEmitter = new HDLKernelNodeEmitter(kt, graph, moduleEmitter)
        nodeEmitter.start
        graph.blocks.foreach(sb => nodeEmitter.emit(sb))
        nodeEmitter.stop

        // Write any required submodules.
        writeLeft(moduleEmitter.getOutput)
        write

        // Start the always block for the code.
        write("always @(posedge clk) begin")
        enter

        // Emit code.
        write(nodeEmitter)

        leave
        write("end")    // end always

        leave
        write("endmodule")

        emitFunctionHDL

        getOutput
    }

    override def emit(dir: File) {

        // Create the block directory.
        val parent = new File(dir, kt.name)
        parent.mkdir

        // Generate the HDL.
        val hdlFile = new File(parent, kt.name + ".v")
        val headerPS = new PrintStream(new FileOutputStream(hdlFile))
        headerPS.print(emitHDL)
        headerPS.close

    }

}
