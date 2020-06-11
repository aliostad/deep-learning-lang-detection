/*
 * Copyright Aduna (http://www.aduna-software.com/) (c) 2007.
 *
 * Licensed under the Aduna BSD-style license.
 */
package org.openrdf.repository.config;

import static org.openrdf.repository.config.RepositoryConfigSchema.REPOSITORYID;
import static org.openrdf.repository.config.RepositoryConfigSchema.REPOSITORY_CONTEXT;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.openrdf.model.Graph;
import org.openrdf.model.Literal;
import org.openrdf.model.Resource;
import org.openrdf.model.Statement;
import org.openrdf.model.ValueFactory;
import org.openrdf.model.impl.GraphImpl;
import org.openrdf.model.vocabulary.RDF;
import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.RepositoryResult;

public class RepositoryConfigUtil {

	public static Set<String> getRepositoryIDs(Repository repository)
		throws RepositoryException
	{
		RepositoryConnection con = repository.getConnection();
		try {
			Set<String> idSet = new LinkedHashSet<String>();

			RepositoryResult<Statement> idStatementIter = con.getStatements(null, REPOSITORYID, null, true);
			try {
				while (idStatementIter.hasNext()) {
					Statement idStatement = idStatementIter.next();

					if (idStatement.getObject() instanceof Literal) {
						Literal idLiteral = (Literal)idStatement.getObject();
						idSet.add(idLiteral.getLabel());
					}
				}
			}
			finally {
				idStatementIter.close();
			}

			return idSet;
		}
		finally {
			con.close();
		}
	}

	/**
	 * Is configuration information for the specified repository ID present in
	 * the (system) repository?
	 * 
	 * @param repository
	 *        the repository to look in
	 * @param repositoryID
	 *        the repositoryID to look for
	 * @return true if configurion information for the specified repository ID
	 *         was found, false otherwise
	 * @throws RepositoryException
	 *         if an error occurred while trying to retrieve information from the
	 *         (system) repository
	 * @throws RepositoryConfigException
	 */
	public static boolean hasRepositoryConfig(Repository repository, String repositoryID)
		throws RepositoryException, RepositoryConfigException
	{
		RepositoryConnection con = repository.getConnection();
		try {
			return getIDStatement(con, repositoryID) != null;
		}
		finally {
			con.close();
		}
	}

	public static RepositoryConfig getRepositoryConfig(Repository repository, String repositoryID)
		throws RepositoryConfigException, RepositoryException
	{
		RepositoryConnection con = repository.getConnection();
		try {
			Statement idStatement = getIDStatement(con, repositoryID);
			if (idStatement == null) {
				// No such config
				return null;
			}

			Resource repositoryNode = idStatement.getSubject();
			Resource context = idStatement.getContext();

			if (context == null) {
				throw new RepositoryException("No configuration context for repository " + repositoryID);
			}

			Graph contextGraph = new GraphImpl();
			con.getStatements(null, null, null, true, context).addTo(contextGraph);

			return RepositoryConfig.create(contextGraph, repositoryNode);
		}
		finally {
			con.close();
		}
	}

	/**
	 * Update the specified Repository with the specified set of
	 * RepositoryConfigs. This will overwrite all existing configurations in the
	 * Repository that have a Repository ID occurring in these RepositoryConfigs.
	 * 
	 * @param repository
	 *        The Repository whose contents will be modified.
	 * @param configs
	 *        The RepositoryConfigs that should be added to or updated in the
	 *        Repository. The RepositoryConfig's ID may already occur in the
	 *        Repository, in which case all previous configuration data for that
	 *        Repository will be cleared before the RepositoryConfig is added.
	 * @throws RepositoryException
	 *         When access to the Repository's RepositoryConnection causes a
	 *         RepositoryException.
	 * @throws RepositoryConfigException
	 */
	public static void updateRepositoryConfigs(Repository repository, RepositoryConfig... configs)
		throws RepositoryException, RepositoryConfigException
	{
		RepositoryConnection con = repository.getConnection();

		try {
			updateRepositoryConfigs(con, configs);
		}
		finally {
			con.close();
		}
	}

	/**
	 * Update the specified RepositoryConnection with the specified set of
	 * RepositoryConfigs. This will overwrite all existing configurations in the
	 * Repository that have a Repository ID occurring in these RepositoryConfigs.
	 * 
	 * Note: this method does NOT commit the updates on the connection.
	 * 
	 * @param con
	 *        the repository connection to perform the update on
	 * @param configs
	 *        The RepositoryConfigs that should be added to or updated in the
	 *        Repository. The RepositoryConfig's ID may already occur in the
	 *        Repository, in which case all previous configuration data for that
	 *        Repository will be cleared before the RepositoryConfig is added.
	 * 
	 * @throws RepositoryException
	 * @throws RepositoryConfigException
	 */
	public static void updateRepositoryConfigs(RepositoryConnection con, RepositoryConfig... configs)
		throws RepositoryException, RepositoryConfigException
	{
		ValueFactory vf = con.getRepository().getValueFactory();

		boolean wasAutoCommit = con.isAutoCommit();
		con.setAutoCommit(false);

		for (RepositoryConfig config : configs) {
			Resource context = getContext(con, config.getID());

			if (context != null) {
				con.clear(context);
			}
			else {
				context = vf.createBNode();
			}

			con.add(context, RDF.TYPE, REPOSITORY_CONTEXT);

			Graph graph = new GraphImpl(vf);
			config.export(graph);
			con.add(graph, context);
		}

		con.setAutoCommit(wasAutoCommit);
	}

	/**
	 * Removes one or more Repository configurations from a Repository. Nothing
	 * happens when this Repository does not contain configurations for these
	 * Repository IDs.
	 * 
	 * @param repository
	 *        The Repository to remove the configurations from.
	 * @param repositoryIDs
	 *        The IDs of the Repositories whose configurations need to be
	 *        removed.
	 * @throws RepositoryException
	 *         Whenever access to the Repository's RepositoryConnection causes a
	 *         RepositoryException.
	 * @throws RepositoryConfigException
	 */
	public static boolean removeRepositoryConfigs(Repository repository, String... repositoryIDs)
		throws RepositoryException, RepositoryConfigException
	{
		boolean changed = false;

		RepositoryConnection con = repository.getConnection();
		try {
			con.setAutoCommit(false);

			for (String id : repositoryIDs) {
				Resource context = getContext(con, id);
				if (context != null) {
					con.clear(context);
					con.remove(context, RDF.TYPE, REPOSITORY_CONTEXT);
					changed = true;
				}
			}

			con.commit();
		}
		finally {
			con.close();
		}

		return changed;
	}

	public static Resource getContext(RepositoryConnection con, String repositoryID)
		throws RepositoryException, RepositoryConfigException
	{
		Resource context = null;

		Statement idStatement = getIDStatement(con, repositoryID);
		if (idStatement != null) {
			context = idStatement.getContext();
		}

		return context;
	}

	private static Statement getIDStatement(RepositoryConnection con, String repositoryID)
		throws RepositoryException, RepositoryConfigException
	{
		Literal idLiteral = con.getRepository().getValueFactory().createLiteral(repositoryID);
		List<Statement> idStatementList = con.getStatements(null, REPOSITORYID, idLiteral, true).asList();

		if (idStatementList.size() == 1) {
			return idStatementList.get(0);
		}
		else if (idStatementList.isEmpty()) {
			return null;
		}
		else {
			throw new RepositoryConfigException("Multiple ID-statements for repository ID " + repositoryID);
		}
	}
}
