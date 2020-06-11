/*******************************************************************************
 * Copyright (c) 2004, 2010 Eugene Kuleshov and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eugene Kuleshov - initial API and implementation
 *******************************************************************************/

package org.eclipse.mylyn.internal.tasks.core;

import org.eclipse.mylyn.tasks.core.AbstractRepositoryConnector;
import org.eclipse.mylyn.tasks.core.TaskRepository;

/**
 * Task repository filter to build list of repositories with required capabilities.
 * 
 * @author Eugene Kleshov
 * @since 2.0
 */
public interface ITaskRepositoryFilter {

	public static ITaskRepositoryFilter ALL = new ITaskRepositoryFilter() {
		public boolean accept(TaskRepository repository, AbstractRepositoryConnector connector) {
			return true;
		}
	};

	public static ITaskRepositoryFilter CAN_QUERY = new ITaskRepositoryFilter() {
		public boolean accept(TaskRepository repository, AbstractRepositoryConnector connector) {
			return !(connector instanceof LocalRepositoryConnector) && !repository.isOffline()
					&& connector.canQuery(repository);
		}
	};

	public static ITaskRepositoryFilter CAN_CREATE_NEW_TASK = new ITaskRepositoryFilter() {
		public boolean accept(TaskRepository repository, AbstractRepositoryConnector connector) {
			return connector.canCreateNewTask(repository) && !repository.isOffline();
		}
	};

	public static ITaskRepositoryFilter CAN_CREATE_TASK_FROM_KEY = new ITaskRepositoryFilter() {
		public boolean accept(TaskRepository repository, AbstractRepositoryConnector connector) {
			return connector.canCreateTaskFromKey(repository) && !repository.isOffline();
		}
	};

	public static ITaskRepositoryFilter IS_USER_MANAGED = new ITaskRepositoryFilter() {
		public boolean accept(TaskRepository repository, AbstractRepositoryConnector connector) {
			return connector.isUserManaged();
		}
	};

	public static ITaskRepositoryFilter CAN_CREATE_REPOSITORY = new ITaskRepositoryFilter() {
		public boolean accept(TaskRepository repository, AbstractRepositoryConnector connector) {
			return connector.canCreateRepository();
		}
	};

	public abstract boolean accept(TaskRepository repository, AbstractRepositoryConnector connector);

}
