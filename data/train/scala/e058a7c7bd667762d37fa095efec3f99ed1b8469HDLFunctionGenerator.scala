package scalapipe.gen

import scalapipe._
import scalapipe.opt.ASTOptimizer
import scalapipe.opt.IROptimizer

private[scalapipe] class HDLFunctionGenerator(
        val ft: InternalFunctionType
    ) extends HDLKernelGenerator(ft) {

    private var stateCount = 0
    private val moduleEmitter = new HDLModuleEmitter(kt, graph)

    protected override def emitFunctionHDL {

        val functionName = ft.name

        // Write the module header.
        write("module " + functionName + "(")
        enter
        write("clk, start,")
        for (a <- ft.inputs) {
            write(emitSymbol(a) + ",")
        }
        if (ft.ramDepth > 0) {
            write("ram_addr,")
            write("ram_in,")
            write("ram_out,")
            write("ram_mask,")
            write("ram_we,")
            write("ram_re,")
            write("ram_ready,")
        }
        write("result_out, ready_out);")

        // Width configuration.  This is needed for compatability with
        // the built-in functions.
        write("parameter WIDTH = " + ft.returnType.bits + ";")

        // I/O declarations.
        write("input wire clk;")
        write("input wire start;")
        for (i <- ft.inputs) {
            val pts = getTypeString(emitSymbol(i), i.valueType)
            write(s"input wire $pts;")
        }
        if (ft.ramDepth > 0) {
            val wordBytes = ramWidth / 8;
            write(s"output reg [${ramAddrWidth - 1}:0] ram_addr;")
            write(s"input wire [${ramWidth - 1}:0] ram_in;")
            write(s"output reg [${ramWidth - 1}:0] ram_out;")
            write(s"output reg [${wordBytes - 1}:0] ram_mask;")
            write(s"output reg ram_re;")
            write(s"output reg ram_we;")
            write(s"input wire ram_ready;")
        }
        val pts = getTypeString("result_out", ft.returnType)
        write(s"output reg $pts;")
        write(s"output wire ready_out;")
        write(s"reg running;")

        emitLocals

        // Assign ready_out.
        write("assign ready_out = state == 0;")

        // Generate code.
        val nodeEmitter = new HDLFunctionNodeEmitter(ft, graph, moduleEmitter)
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

    }

}
