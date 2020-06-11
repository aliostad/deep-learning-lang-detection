package ar.edu.sccs.model.loader.dto;

import java.io.Serializable;

import ar.edu.sccs.dao.RepositoryDTO;

public class DataSCM implements Serializable {

	private static final long serialVersionUID = 1L;

	private String repositoryUrl;
	private String repositoryType;
	private String repositoryServer;
	private String repositoryPort;
	private String repositoryUsr;
	private String repositoryPwd;

	public DataSCM() {
		super();
	}

	public DataSCM(RepositoryDTO r) {
		super();
		repositoryUrl = r.getRepository_name();
		repositoryType = r.getRepository_protocol();
		repositoryServer = r.getRepository_server();
		repositoryPort = r.getRepository_port();
		repositoryUsr = r.getRepository_user();
		repositoryPwd = r.getRepository_password();
	}

	/**
	 * @return the repositoryUrl
	 */
	public String getRepositoryUrl() {
		return repositoryUrl;
	}

	/**
	 * @param repositoryUrl the repositoryUrl to set
	 */
	public void setRepositoryUrl(String repositoryUrl) {
		this.repositoryUrl = repositoryUrl;
	}

	/**
	 * @return the repositoryType
	 */
	public String getRepositoryType() {
		return repositoryType;
	}

	/**
	 * @param repositoryType the repositoryType to set
	 */
	public void setRepositoryType(String repositoryType) {
		this.repositoryType = repositoryType;
	}

	/**
	 * @return the repositoryServer
	 */
	public String getRepositoryServer() {
		return repositoryServer;
	}

	/**
	 * @param repositoryServer the repositoryServer to set
	 */
	public void setRepositoryServer(String repositoryServer) {
		this.repositoryServer = repositoryServer;
	}

	/**
	 * @return the repositoryPort
	 */
	public String getRepositoryPort() {
		return repositoryPort;
	}

	/**
	 * @param repositoryPort the repositoryPort to set
	 */
	public void setRepositoryPort(String repositoryPort) {
		this.repositoryPort = repositoryPort;
	}

	/**
	 * @return the repositoryUsr
	 */
	public String getRepositoryUsr() {
		return repositoryUsr;
	}

	/**
	 * @param repositoryUsr the repositoryUsr to set
	 */
	public void setRepositoryUsr(String repositoryUsr) {
		this.repositoryUsr = repositoryUsr;
	}

	/**
	 * @return the repositoryPwd
	 */
	public String getRepositoryPwd() {
		return repositoryPwd;
	}

	/**
	 * @param repositoryPwd the repositoryPwd to set
	 */
	public void setRepositoryPwd(String repositoryPwd) {
		this.repositoryPwd = repositoryPwd;
	}
}
