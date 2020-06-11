package business;

import repositories.MatchRepository;
import repositories.Repository;
import DBServices.MongoMatchRepository;
import entity.Match;

public class DeleteMatch implements UnitOfWork {
	private MatchRepository matchRepository;
	private Match match;
	
	public DeleteMatch() {
		super();
	}

	@Override
	public boolean run() {
		matchRepository.deleteMatch(match);
		return true;
	}

	@Override
	public void SetRepository(Repository repository) {
		matchRepository = new MongoMatchRepository();
		matchRepository = (MatchRepository) repository;
	}

	public void setMatch(Match match) {
		this.match = new Match();
		this.match = match;
	}


}
