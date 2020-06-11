/**
 * Copyright 2014-2015 SHAF-WORK
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
package org.shaf.core.process.handle;

import org.shaf.core.process.Process;
import org.shaf.core.process.ProcessException;
import org.shaf.core.process.type.comp.CompositeProcess;
import org.shaf.core.process.type.dist.DistributedProcess;
import org.shaf.core.process.type.local.LocalProcess;

/**
 * The {@code ProcessExecException} occurs, when the {@link Process process}
 * execution has failed.
 * 
 * @author Mykola Galushka
 */
@SuppressWarnings("serial")
public class ProcessExecException extends ProcessException {

	/**
	 * Constructs a new {@code ProcessExecException} object.
	 * 
	 * @param message
	 *            the message.
	 */
	public ProcessExecException(final String message) {
		super(message);
	}

	/**
	 * Constructs a new {@code ProcessExecException} object.
	 * 
	 * @param message
	 *            the message.
	 * @param cause
	 *            the cause.
	 */
	public ProcessExecException(final String message, final Throwable cause) {
		super(message, cause);
	}

	/**
	 * Constructs a new {@code ProcessExecException} for the
	 * {@link LocalProcess local process}.
	 * 
	 * @param process
	 *            the failed local process.
	 * @param cause
	 *            the cause.
	 */
	public ProcessExecException(final LocalProcess process,
			final Throwable cause) {
		super("Failed to execute the local process.", cause);
	}

	/**
	 * Constructs a new {@code ProcessExecException} for the
	 * {@link DistributedProcess distributed process}.
	 * 
	 * @param process
	 *            the failed distributed process.
	 * @param cause
	 *            the cause.
	 */
	public ProcessExecException(
			final DistributedProcess<?, ?, ?, ?, ?, ?> process,
			final Throwable cause) {
		super("Failed to execute the distributed process.", cause);
	}

	/**
	 * Constructs a new {@code ProcessExecException} for the
	 * {@link CompositeProcess composite process}.
	 * 
	 * @param process
	 *            the failed composite process.
	 * @param cause
	 *            the cause.
	 */
	public ProcessExecException(final CompositeProcess process,
			final Throwable cause) {
		super("Failed to execute the composite process.", cause);
	}
}
