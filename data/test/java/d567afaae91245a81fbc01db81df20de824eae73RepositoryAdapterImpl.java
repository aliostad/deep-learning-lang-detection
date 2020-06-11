package adapter;

public class RepositoryAdapterImpl extends DefaultRepository implements RepositoryAdapter{

	private DefaultRepository connOp = new DefaultRepository();
	
	@Override
	public Repository getSDA() {
		// TODO Auto-generated method stub
		return connOp.getRepository();
	}

	@Override
	public Repository getS3() {
		// TODO Auto-generated method stub
		Repository repository = getRepository();
		return convertRepository("S3");
	}

	@Override
	public Repository getDspace() {
		// TODO Auto-generated method stub
		Repository repository = getRepository();
		return convertRepository("Dspace");
	}
	
	
	public Repository convertRepository(String name){
		return new Repository(name);
	}

}
