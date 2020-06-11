package cov.mjp.gsw.dataaccess.lucene;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cov.mjp.gsw.dataaccess.VerseRepositoryProvider;

@Service
public class LuceneVerseRepositoryProvider extends VerseRepositoryProvider<LuceneVerseRepository<?,?>> {

	@Autowired
	public LuceneVerseRepositoryProvider(
			LuceneKoranVerseRepository koranRepository,
			LuceneMormonVerseRepository mormonVerseRepository,
			LuceneBibleVerseRepository oldTestamentRepository,
			LuceneBibleVerseRepository oldAndNewTestamentRepository) {
		super(koranRepository, mormonVerseRepository, oldAndNewTestamentRepository, oldTestamentRepository);
	}
}
