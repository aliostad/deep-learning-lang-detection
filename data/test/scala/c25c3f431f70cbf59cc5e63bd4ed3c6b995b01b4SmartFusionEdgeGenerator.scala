package scalapipe.gen

import scalapipe._

/** Edge generator for edges mapped between the CPU and FPGA on a
 *  SmartFusion SoC. */
private[scalapipe] class SmartFusionEdgeGenerator(
        val sp: ScalaPipe
    ) extends EdgeGenerator(Platforms.HDL) {

    override def emitCommon() {
        write(s"#include <sys/ioctl.h>")
    }

    override def emitGlobals(streams: Traversable[Stream]) {

        val devices = getDevices(streams)

        // Write globals for each device.
        for (d <- devices) {

            val fd = d.label + "_fd"
            write(s"static int $fd = -1;")

            val senderStreams = getSenderStreams(d, streams)
            val receiverStreams = getReceiverStreams(d, streams)
            for (stream <- senderStreams ++ receiverStreams) {
                write(s"static APQ *q_${stream.label} = NULL;")
            }

        }

        // Write the send/recv functions.
        for (d <- devices) {

            val senderStreams = getSenderStreams(d, streams)
            val receiverStreams = getReceiverStreams(d, streams)

            if (!senderStreams.isEmpty) {
                writeSendFunctions(d, senderStreams)
            }

            if (!receiverStreams.isEmpty) {
                writeRecvFunctions(d, receiverStreams)
            }

        }

    }

    override def emitInit(streams: Traversable[Stream]) {
        for (d <- getDevices(streams)) {
            writeInit(d, getExternalStreams(d, streams))
        }
    }

    override def emitDestroy(streams: Traversable[Stream]) {
        for (d <- getDevices(streams)) {
            writeDestroy(d, getExternalStreams(d, streams))
        }
    }

    private def writeInit(device: Device, streams: Traversable[Stream]) {

        val senderStreams = getSenderStreams(device, streams)
        val receiverStreams = getReceiverStreams(device, streams)

        // Open the device.
        val fd = device.label + "_fd"
        write(s"""$fd = open(\"/dev/sp\", O_RDWR);""")
        write(s"if($fd < 0) {")
        enter
        write("perror(\"could not open /dev/sp\");")
        write("exit(-1);")
        leave
        write(s"}")

        // Create buffers.
        for (stream <- senderStreams ++ receiverStreams) {
            val depth = stream.parameters.get[Int]('queueDepth)
            val valueType = stream.valueType
            val queueName = s"q_${stream.label}"
            write(s"$queueName = (APQ*)malloc(APQ_GetSize($depth" +
                  s", sizeof($valueType)));")
            write(s"APQ_Initialize($queueName, $depth, sizeof($valueType));")
        }

    }

    private def writeDestroy(device: Device, streams: Traversable[Stream]) {

        val fd = device.label + "_fd"
        write(s"close($fd);")

        for (s <- streams) {
            val queueName = "q_" + s.label
            write(s"free($queueName);")
        }

    }

    private def writeSendFunctions(device: Device,
                                   streams: Traversable[Stream]) {

        val fd = device.label + "_fd"

        // Write the per-stream functions.
        for (stream <- streams) {

            val queueName = "q_" + stream.label
            val valueType = stream.valueType

            // "get_free"
            write(s"static int ${stream.label}_get_free()")
            write(s"{")
            enter
            write(s"return APQ_GetFree($queueName);")
            leave
            write(s"}")

            // "is_empty"
            write(s"static int ${stream.label}_is_empty()")
            write(s"{")
            enter
            write(s"return APQ_IsEmpty($queueName);")
            leave
            write(s"}")

            // "allocate"
            write(s"static void *${stream.label}_allocate(int count)")
            write(s"{")
            enter
            write(s"return APQ_StartWrite($queueName, count);")
            leave
            write(s"}")

            // "send"
            write(s"static void ${stream.label}_send(int count)")
            write(s"{")
            enter
            write(s"APQ_FinishWrite($queueName, count);")
            write(s"char *data;")
            write(s"uint32_t c = APQ_StartRead($queueName, &data);")
            write(s"const ssize_t sz = (sizeof($valueType) + 3) & ~3;")
            write(s"ioctl($fd, 0, ${stream.index});")
            write(s"for(uint32_t i = 0; i < c * sz; i += sz) {");
            enter
            write(s"ssize_t offset = 0;")
            write(s"while(offset < sz) {")
            enter
            write(s"offset += write($fd, &data[i + offset], sz - offset);")
            leave
            write(s"}")
            leave
            write(s"}")
            write(s"APQ_FinishRead($queueName, c);")
            leave
            write(s"}")

        }

    }

    private def writeRecvFunctions(device: Device,
                                             streams: Traversable[Stream]) {

        val fd = device.label + "_fd"

        // Write the per-stream functions.
        for (stream <- streams) {

            val queueName = "q_" + stream.label
            val valueType = stream.valueType
            val destKernel = stream.destKernel
            val destIndex = stream.destIndex
            val destName = destKernel.kernelType.name
            val destLabel = destKernel.label
            val index = stream.index
            val label = stream.label

            // "process"
            write(s"static void ${label}_process()")
            write(s"{")
            enter
            write(s"char *data;")
            write(s"bool got_read;")
            write(s"do {")
            enter
            write(s"got_read = false;")
            write(s"data = APQ_StartWrite($queueName, 1);")
            write(s"if(data != NULL) {")
            enter
            write(s"ioctl($fd, 0, $index);")
            if (valueType.bits <= 32) {
                write(s"ssize_t offset = 0;")
                write(s"UNSIGNED32 temp;")
                write(s"offset = read($fd, &temp, 4);")
                write(s"if(offset > 0) {")
                enter
                write(s"memcpy(data, &temp, sizeof($valueType));")
                write(s"got_read = true;")
                write(s"APQ_FinishWrite($queueName, 1);")
                leave
                write(s"}")
            } else {
                write(s"ssize_t offset = 0;")
                write(s"const ssize_t sz = (sizeof($valueType) + 3) & ~3;")
                write(s"offset = read($fd, &data[0], sz);")
                write(s"if(offset > 0) {")
                enter
                write(s"while(offset < sz) {")
                enter
                write(s"offset += read($fd, &data[offset], sz - offset);")
                leave
                write(s"}")
                write(s"got_read = true;")
                write(s"APQ_FinishWrite($queueName, 1);")
                leave
                write(s"}")
                leave
                write(s"}")
            }
            leave
            write(s"} while(got_read);")
            write

            write(s"if(!APQ_IsEmpty($queueName) && " +
                    "${destLabel}.inputs[$destIndex].data == NULL) {")
            enter
            write(s"uint32_t c = APQ_StartBlockingRead($queueName, &data);")
            write(s"${destLabel}.inputs[$destIndex].data = ($valueType*)data;")
            write(s"${destLabel}.inputs[$destIndex].count = c;")
            write(s"${destLabel}.clock.count += 1;")
            write(s"APC_Start(&$destLabel.clock);")
            write(s"ap_${destName}_push(&$destLabel.priv, $destIndex, " +
                    "$destLabel.inputs[$destIndex].data, c);")
            write(s"APC_Stop(&$destLabel.clock);")
            leave
            write(s"}")
            write

            leave
            write(s"}")

            // "release"
            write(s"static void ${label}_release(int count)")
            write(s"{")
            enter
            write(s"APQ_FinishRead($queueName, count);")
            leave
            write(s"}")

        }

    }

}
