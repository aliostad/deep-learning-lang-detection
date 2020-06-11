/**
 * @author ricardo
 */

package edu.uci.ics.mondego.codegenie.localrepository;

import edu.uci.ics.mondego.codegenie.search.TreeObjectBase;
import edu.uci.ics.mondego.codegenie.util.JavaTermExtractor;

public class LocalRepositoryTreeLeaf extends TreeObjectBase {

	protected RepositoryEntity repositoryEntity = null;

	public LocalRepositoryTreeLeaf(RepositoryEntity repositoryEntity) {
		super (JavaTermExtractor.getNameAndParams(repositoryEntity.searchResultEntry.getEntry()));
		this.repositoryEntity = repositoryEntity;
	}

	public RepositoryEntity getRepositoryEntity() {
		return repositoryEntity;
	}
	
	public void setRepositoryEntity(RepositoryEntity repositoryEntity) {
		this.repositoryEntity = repositoryEntity;
	}
	
	public void computeNumberOfChildrenUp() {};


}
