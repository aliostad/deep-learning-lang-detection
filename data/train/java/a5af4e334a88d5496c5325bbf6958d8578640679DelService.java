package business;

import DBServices.MongoServiRepository;
import entity.Servi;
import repositories.Repository;
import repositories.ServiRepository;

public class DelService implements UnitOfWork{

	private ServiRepository serviRepository;
	private Servi servi;
	
	public DelService() {
		super();
	}

	@Override
	public boolean run() {
		serviRepository.deleteServi(servi);
		return true;
	}

	@Override
	public void SetRepository(Repository repository) {
		serviRepository = new MongoServiRepository();
		serviRepository = (ServiRepository) repository;
	}

	public void setServi(Servi servicio) {
		servi = new Servi();
		servi = servicio;
	}

}
