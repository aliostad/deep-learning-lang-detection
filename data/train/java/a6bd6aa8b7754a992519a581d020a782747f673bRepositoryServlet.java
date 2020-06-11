/*
 * Copyright Aduna (http://www.aduna-software.com/) (c) 2008.
 *
 * Licensed under the Aduna BSD-style license.
 */
package org.openrdf.workbench;

import javax.servlet.Servlet;

import org.openrdf.repository.Repository;
import org.openrdf.repository.manager.RepositoryInfo;
import org.openrdf.repository.manager.RepositoryManager;

public interface RepositoryServlet extends Servlet {

	void setRepositoryManager(RepositoryManager manager);

	void setRepositoryInfo(RepositoryInfo info);

	void setRepository(Repository repository);
}
