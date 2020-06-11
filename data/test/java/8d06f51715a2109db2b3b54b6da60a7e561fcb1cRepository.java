package schema;

import annotation.B;
import annotation.L;
import annotation.M;
import annotation.P;

public class Repository implements IEntity {
	
	@M("²Ö¿âÎ¨Ò»±àºÅ")
	@L(30)
	@B
	@P
	Integer repositoryId;

	@M("Ãû³Æ")
	@L(30)
	String repositoryName;

	public String toString() {
		return " repositoryId: " + repositoryId + " repositoryName: " + repositoryName;
	}

	public Integer getRepositoryId() {
		return repositoryId;
	}

	public void setRepositoryId(Integer repositoryId) {
		this.repositoryId = repositoryId;
	}

	public String getRepositoryName() {
		return repositoryName;
	}

	public void setRepositoryName(String repositoryName) {
		this.repositoryName = repositoryName;
	}
}
