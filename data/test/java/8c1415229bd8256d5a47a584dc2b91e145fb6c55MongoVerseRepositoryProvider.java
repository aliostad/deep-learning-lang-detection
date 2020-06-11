package cov.mjp.gsw.dataaccess.mongo.repo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cov.mjp.gsw.dataaccess.VerseRepositoryProvider;

@Service
public class MongoVerseRepositoryProvider extends VerseRepositoryProvider<MongoVerseRepository<?,?>> {

	@Autowired
	public MongoVerseRepositoryProvider(
			MongoKoranVerseRepository koranRepository,
			MongoMormonVerseRepository mormonVerseRepository,
			MongoOldTestamentVerseRepository oldTestamentRepository,
			MongoBibleVerseRepository oldAndNewTestamentRepository) {
		super(koranRepository, mormonVerseRepository, oldAndNewTestamentRepository, oldTestamentRepository);
	}
}
