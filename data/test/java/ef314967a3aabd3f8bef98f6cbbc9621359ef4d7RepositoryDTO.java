package ar.edu.sccs.dao;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;

public class RepositoryDTO {

	private Integer repository_id;
	private String repository_name;
	private String repository_protocol;
	private String repository_server;
	private String repository_port;
	private String repository_user;
	private String repository_password;

	@Override
	public String toString() {
		return ReflectionToStringBuilder.reflectionToString(this, ToStringStyle.MULTI_LINE_STYLE);
	}

	/**
	 * @return the repository_id
	 */
	public Integer getRepository_id() {
		return repository_id;
	}
	/**
	 * @param repository_id the repository_id to set
	 */
	public void setRepository_id(Integer repository_id) {
		this.repository_id = repository_id;
	}
	/**
	 * @return the repository_name
	 */
	public String getRepository_name() {
		return repository_name;
	}
	/**
	 * @param repository_name the repository_name to set
	 */
	public void setRepository_name(String repository_name) {
		this.repository_name = repository_name;
	}
	/**
	 * @return the repository_protocol
	 */
	public String getRepository_protocol() {
		return repository_protocol;
	}
	/**
	 * @param repository_protocol the repository_protocol to set
	 */
	public void setRepository_protocol(String repository_protocol) {
		this.repository_protocol = repository_protocol;
	}
	/**
	 * @return the repository_server
	 */
	public String getRepository_server() {
		return repository_server;
	}
	/**
	 * @param repository_server the repository_server to set
	 */
	public void setRepository_server(String repository_server) {
		this.repository_server = repository_server;
	}
	/**
	 * @return the repository_port
	 */
	public String getRepository_port() {
		return repository_port;
	}
	/**
	 * @param repository_port the repository_port to set
	 */
	public void setRepository_port(String repository_port) {
		this.repository_port = repository_port;
	}
	/**
	 * @return the repository_user
	 */
	public String getRepository_user() {
		return repository_user;
	}
	/**
	 * @param repository_user the repository_user to set
	 */
	public void setRepository_user(String repository_user) {
		this.repository_user = repository_user;
	}
	/**
	 * @return the repository_password
	 */
	public String getRepository_password() {
		return repository_password;
	}
	/**
	 * @param repository_password the repository_password to set
	 */
	public void setRepository_password(String repository_password) {
		this.repository_password = repository_password;
	}
}
