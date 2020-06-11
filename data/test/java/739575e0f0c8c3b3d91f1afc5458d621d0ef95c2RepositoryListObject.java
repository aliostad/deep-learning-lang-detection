package nam.model.repository;

import java.io.Serializable;

import org.aries.ui.AbstractListObject;

import nam.model.Repository;
import nam.model.util.RepositoryUtil;


public class RepositoryListObject extends AbstractListObject<Repository> implements Comparable<RepositoryListObject>, Serializable {
	
	private Repository repository;
	
	
	public RepositoryListObject(Repository repository) {
		this.repository = repository;
	}
	
	
	public Repository getRepository() {
		return repository;
	}
	
	@Override
	public Object getKey() {
		return getKey(repository);
	}
	
	public Object getKey(Repository repository) {
		return RepositoryUtil.getKey(repository);
	}
	
	@Override
	public String getLabel() {
		return getLabel(repository);
	}
	
	public String getLabel(Repository repository) {
		return RepositoryUtil.getLabel(repository);
	}
	
	@Override
	public String toString() {
		return toString(repository);
	}
	
	@Override
	public String toString(Repository repository) {
		return RepositoryUtil.toString(repository);
	}
	
	@Override
	public int compareTo(RepositoryListObject other) {
		Object thisKey = getKey(this.repository);
		Object otherKey = getKey(other.repository);
		String thisText = thisKey.toString();
		String otherText = otherKey.toString();
		return thisText.compareTo(otherText);
	}
	
	@Override
	public boolean equals(Object object) {
		RepositoryListObject other = (RepositoryListObject) object;
		Object thisKey = RepositoryUtil.getKey(this.repository);
		Object otherKey = RepositoryUtil.getKey(other.repository);
		if (thisKey == null)
			return false;
		if (otherKey == null)
			return false;
		return thisKey.equals(otherKey);
	}
	
}
