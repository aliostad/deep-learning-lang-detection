package scalapipe.gen

import scalapipe._

private[scalapipe] class SockEdgeGenerator(
        val sp: ScalaPipe,
        val host: String
    ) extends EdgeGenerator(Platforms.C) with CGenerator {

    private def isProducer(s: Stream): Boolean = {
        s.sourceKernel.device.host == host
    }

    override def emitCommon() {
        write("#include <sys/types.h>")
        write("#include <sys/socket.h>")
        write("#include <netinet/in.h>")
        write("#include <netinet/tcp.h>")
        write("#include <arpa/inet.h>")
        write("#include <sys/ioctl.h>")
        write("#include <netdb.h>")
        write("#include <fcntl.h>")
        write("#include <errno.h>")
        write("#include <unistd.h>")
        write("#include <poll.h>")
    }

    override def emitGlobals(streams: Traversable[Stream]) {
        streams.foreach { s =>
            if (isProducer(s)) {
                writeProducerGlobals(s)
            } else {
                writeConsumerGlobals(s)
            }
        }
    }

    override def emitInit(streams: Traversable[Stream]) {
        streams.foreach { s =>
            if (isProducer(s)) {
                writeInitProducer(s)
            } else {
                writeInitConsumer(s)
            }
        }
    }

    override def emitDestroy(streams: Traversable[Stream]) {
        streams.foreach { s =>
            if (isProducer(s)) {
                writeDestroyProducer(s)
            } else {
                writeDestroyConsumer(s)
            }
        }
    }

    private def writeProducerGlobals(stream: Stream) {

        val sock = s"sock${stream.label}"
        val bufname = s"buffer${stream.label}"
        val vtype = stream.valueType

        // Globals.
        write(s"static int $sock = 0;")
        write(s"static char *$bufname = NULL;")
        write(s"static struct")
        enter
        write(s"volatile uint32_t active_inputs;")
        leave
        write(s"${stream.destKernel.label};")

        // "get_free"
        write(s"static bool ${stream.label}_get_free()")
        enter
        write(s"static int size = 0;")
        writeIf(s"SPUNLIKELY(size == 0)")
        write(s"socklen_t olen = sizeof(size);")
        write(s"getsockopt($sock, SOL_SOCKET, SO_SNDBUF, &size, &olen);")
        writeEnd
        write(s"int usage = 0;")
        write(s"ioctl($sock, TIOCOUTQ, &usage);")
        writeReturn(s"(size - usage) / sizeof($vtype)")
        leave

        // "allocate"
        write(s"static void *${stream.label}_allocate()")
        enter
        write(s"static size_t size = 0;")
        write(s"const size_t temp = sizeof($vtype);")
        writeIf(s"SPUNLIKELY(temp > size)")
        write(s"size = temp;")
        write(s"$bufname = (char*)realloc($bufname, size);")
        writeEnd
        writeReturn(bufname)
        leave

        // "send"
        write(s"static void ${stream.label}_send()")
        enter
        write(s"const size_t size = sizeof($vtype);")
        write(s"const int c = send($sock, $bufname, size, 0);")
        writeIf(s"SPUNLIKELY(c < 0)")
        write("perror(\"send failed\");")
        write("exit(-1);")
        writeEnd
        leave

        // "finish"
        write(s"static void ${stream.label}_finish()")
        enter
        writeReturn()
        leave

    }

    private def writeProcess(stream: Stream) {

        val sock = s"sock${stream.label}"
        val lsock = s"server${stream.label}"
        val qname = s"q_${stream.label}"
        val vtype = stream.valueType
        val destLabel = stream.destKernel.label

        write(s"static void ${stream.label}_process()")
        enter
        write(s"static ssize_t leftovers = 0;")
        write(s"static char *ptr = NULL;")

        // Check if this socket has already been closed.
        writeIf(s"SPUNLIKELY($sock < 0)")
        writeReturn()
        writeEnd

        // Attempt to connect if the connection has yet to be established.
        write(s"while(SPUNLIKELY($sock == 0))")
        enter
        write(s"struct sockaddr_in caddr;")
        write(s"socklen_t caddrlen = sizeof(caddr);")
        write(s"$sock = accept($lsock, (struct sockaddr*)&caddr, &caddrlen);")
        writeIf(s"$sock < 0")
        write("perror(\"accept\");")
        write("exit(-1);")
        writeEnd
        leave

        // Check for activity.
        write(s"struct pollfd fds;")
        write(s"fds.fd = $sock;")
        write(s"fds.events = POLLIN;")
        writeIf(s"poll(&fds, 1, 0) == 0")
        writeReturn()
        writeEnd

        // Check for available data.
        writeIf(s"SPLIKELY(fds.revents & POLLIN)")
        write(s"size_t max_size;")
        writeIf(s"leftovers > 0")
        write(s"max_size = sizeof($vtype) - leftovers;")
        writeElse
        write(s"const size_t max_count = ${qname}->depth >> 3;")
        write(s"max_size = sizeof($vtype) * max_count;")
        write(s"ptr = (char*)spq_start_write($qname, max_count);")
        writeEnd
        writeIf(s"ptr != NULL")
        write(s"ssize_t rc = recv($sock, ptr, max_size, 0);")
        writeIf(s"SPUNLIKELY(rc == 0)")
        write(s"sp_decrement(&$destLabel.active_inputs);")
        write(s"close($sock);")
        write(s"$sock = -1;")
        writeElseIf(s"SPUNLIKELY(rc < 0)")
        write("perror(\"recv\");")
        write("exit(-1);")
        writeEnd
        write(s"const size_t total = rc + leftovers;")
        write(s"const size_t count = total / sizeof($vtype);")
        write(s"leftovers = total % sizeof($vtype);")
        write(s"ptr += rc;")
        write(s"spq_finish_write($qname, count);")
        writeEnd
        writeReturn()
        writeEnd    // Data available.

        // Error if we got here.
        write("perror(\"poll\");")
        write("exit(-1);")

        leave

    }

    private def writeConsumerGlobals(stream: Stream) {

        val sock = s"sock${stream.label}"
        val lsock = s"server${stream.label}"
        val qname = s"q_${stream.label}"

        // Globals.
        write(s"static int $sock = 0;")
        write(s"static int $lsock = 0;")
        write(s"static SPQ *$qname = NULL;")

        // Read from the socket.
        writeProcess(stream)

        // "get_available"
        write(s"static int ${stream.label}_get_available()")
        enter
        write(s"${stream.label}_process();")
        writeReturn(s"spq_get_used($qname);")
        leave

        // "read_value"
        write(s"static void *${stream.label}_read_value()")
        enter
        write(s"char *buffer;")
        write(s"${stream.label}_process();")
        writeIf(s"spq_start_read($qname, &buffer) > 0")
        writeReturn(s"buffer")
        writeElse
        writeReturn(s"NULL")
        writeEnd
        leave

        // "release"
        write(s"static void ${stream.label}_release()")
        enter
        write(s"spq_finish_read($qname, 1);")
        leave

    }

    private def writeInitProducer(stream: Stream) {

        val sock = s"sock${stream.label}"
        val remoteHost = stream.destKernel.device.host
        val port = sp.getPort(stream)

        // Create the client socket and connect to the server.
        enter
        write(s"struct hostent *host;")
        write("host = gethostbyname(\"" + remoteHost + "\");")
        writeIf("host == NULL")
        write("perror(\"gethostbyname\");")
        write("exit(-1);")
        writeEnd
        write(s"for(;;)")
        enter
        write(s"$sock = socket(PF_INET, SOCK_STREAM, 0);")
        writeIf(s"$sock < 0")
        write("perror(\"socket\");")
        write("exit(-1);")
        writeEnd
        write(s"struct sockaddr_in addr;")
        write(s"memset(&addr, 0, sizeof(addr));")
        write(s"addr.sin_family = PF_INET;")
        write(s"addr.sin_port = $port;")
        write(s"addr.sin_addr = *(struct in_addr*)host->h_addr;")
        write(s"int rc = connect($sock, (struct sockaddr*)&addr, " +
              s"sizeof(addr));")
        writeIf("rc")
        writeIf("errno != ECONNREFUSED")
        write("perror(\"connect\");")
        write("exit(-1);")
        writeElse
        write(s"close($sock);")
        write(s"usleep(100);")
        writeEnd
        writeElse
        write("break;")
        writeEnd
        leave
        leave

    }

    private def writeInitConsumer(stream: Stream) {

        val lsock = s"server${stream.label}"
        val qname = s"q_${stream.label}"
        val depth = stream.parameters.get[Int]('queueDepth)
        val vtype = stream.valueType
        val port = sp.getPort(stream)

        // Initialize the queue.
        write(s"$qname = (SPQ*)malloc(spq_get_size($depth, sizeof($vtype)));")
        write(s"spq_init($qname, $depth, sizeof($vtype));")

        // Create the server socket.
        enter
        write(s"$lsock = socket(PF_INET, SOCK_STREAM, 0);")
        writeIf(s"$lsock < 0")
        write("perror(\"socket\");")
        write("exit(-1);")
        writeEnd
        write(s"struct sockaddr_in addr;")
        write(s"memset(&addr, 0, sizeof(addr));")
        write(s"addr.sin_family = PF_INET;")
        write(s"addr.sin_port = $port;")
        write(s"int rc = bind($lsock, (struct sockaddr*)&addr, sizeof(addr));")
        writeIf(s"rc")
        write("perror(\"bind\");")
        write("exit(-1);")
        writeEnd
        write(s"rc = listen($lsock, 1);")
        writeIf(s"rc")
        write("perror(\"listen\");")
        write("exit(-1);")
        writeEnd
        leave

    }

    private def writeDestroyProducer(stream: Stream) {
        val sock = s"sock${stream.label}"
        writeIf(s"$sock")
        write(s"close($sock);")
        writeEnd
    }

    private def writeDestroyConsumer(stream: Stream) {

        val qname = s"q_${stream.label}"
        val sock = s"sock${stream.label}"
        val lsock = s"server${stream.label}"

        writeIf(s"$sock")
        write(s"close($sock);")
        writeEnd
        writeIf(s"$lsock")
        write(s"close($lsock);")
        writeEnd
        write(s"free($qname);")

    }

}
