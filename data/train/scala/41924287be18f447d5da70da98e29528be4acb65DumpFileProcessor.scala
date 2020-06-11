/*
 * bytefrog: a tracing framework for the JVM. For more information
 * see http://code-pulse.com/bytefrog
 *
 * Copyright (C) 2014 Applied Visions - http://securedecisions.avi.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.secdec.bytefrog.clients.common.data.processing.processors

import java.io.BufferedOutputStream
import java.io.DataOutputStream
import java.io.File
import java.io.FileOutputStream

import com.secdec.bytefrog.common.message.MessageProtocol
import com.secdec.bytefrog.hq.data.processing.DataProcessor
import com.secdec.bytefrog.hq.protocol.DataMessageContent

object DumpFileProcessor {
	def apply(output: File, protocol: MessageProtocol) = new DumpFileProcessor(output, protocol)
}

/** The DumpFileProcessor simply dumps all data directly to a dump file, so it can be re-processed later
  * should the cptrace file format change.
  *
  * @author robertf
  */
class DumpFileProcessor(output: File, protocol: MessageProtocol) extends DataProcessor {
	import DataMessageContent._

	private val dumpStream = new DataOutputStream(new BufferedOutputStream(new FileOutputStream(output)))

	private var _seq = 0
	private def seq = {
		val s = _seq
		_seq += 1
		s
	}

	def processMessage(message: DataMessageContent) = message match {
		case MapThreadName(name, id, ts) => protocol.writeMapThreadName(dumpStream, id, ts, name)
		case MapMethodSignature(signature, id) => protocol.writeMapMethodSignature(dumpStream, id, signature)
		case MapException(exception, id) => protocol.writeMapException(dumpStream, id, exception)
		case MethodEntry(method, ts, thread) => protocol.writeMethodEntry(dumpStream, ts, seq, method, thread)
		case MethodExit(method, ts, line, thread) => protocol.writeMethodExit(dumpStream, ts, seq, method, line, thread)
		case Exception(exception, method, ts, line, thread) => protocol.writeException(dumpStream, ts, seq, method, exception, line, thread)
		case ExceptionBubble(exception, method, ts, thread) => protocol.writeExceptionBubble(dumpStream, ts, seq, method, exception, thread)
		case Marker(key, value, ts) => protocol.writeMarker(dumpStream, key, value, ts, seq)
	}

	def processDataBreak {
		protocol.writeDataBreak(dumpStream, _seq)
	}

	def finishProcessing() {
		dumpStream.close
	}

	def cleanup() {
		dumpStream.close
	}
}