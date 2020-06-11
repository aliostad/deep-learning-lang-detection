package de.mbentwicklung.jcrviewer.core.repositories.setups;

import java.io.File;

import de.mbentwicklung.jcrviewer.core.repositories.SupportedRepositories;

/**
 * Setup Informationen für ein Jackrabbit Repository
 * 
 * @author Marc Bellmann <marc.bellmann@mb-entwicklung.de>
 */
public class JackrabbitSetup extends Setup {

	/** Path to repository.xml */
	private File repositoryXmlFile;

	/** Path to repository dir */
	private File repositoryDirFile;

	/**
	 * Default Konstruktor
	 */
	public JackrabbitSetup() {
		super();
		setRepositoryType(SupportedRepositories.JACKRABBIT);
	}

	/**
	 * Konstruktor zum Setzen aller Informationen
	 * 
	 * @param repositoryXmlFile
	 *            {@link #repositoryXmlFile}
	 * @param repositoryDirFile
	 *            {@link #repositoryDirFile}
	 * @param username
	 *            Username
	 * @param password
	 *            Password
	 */
	public JackrabbitSetup(final File repositoryXmlFile, final File repositoryDirFile,
			final String username, final String password) {
		super(SupportedRepositories.JACKRABBIT, username, password);

		this.repositoryXmlFile = repositoryXmlFile;
		this.repositoryDirFile = repositoryDirFile;
	}

	/**
	 * Getter for {@link #repositoryXmlFile}
	 * 
	 * @return the repositoryXmlFile
	 */
	public File getRepositoryXmlFile() {
		return repositoryXmlFile;
	}

	/**
	 * Setter for {@link #repositoryXmlFile}
	 * 
	 * @param repositoryXmlFile
	 *            the repositoryXmlFile to set
	 */
	public void setRepositoryXmlFile(final File repositoryXmlFile) {
		this.repositoryXmlFile = repositoryXmlFile;
	}

	/**
	 * Getter for {@link #repositoryDirFile}
	 * 
	 * @return the repositoryDirFile
	 */
	public File getRepositoryDirFile() {
		return repositoryDirFile;
	}

	/**
	 * Setter for {@link #repositoryDirFile}
	 * 
	 * @param repositoryDirFile
	 *            the repositoryDirFile to set
	 */
	public void setRepositoryDirFile(final File repositoryDirFile) {
		this.repositoryDirFile = repositoryDirFile;
	}
}
