package cov.mjp.gsw.dataaccess.jpa.repo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.NoRepositoryBean;
import org.springframework.stereotype.Service;

import cov.mjp.gsw.dataaccess.VerseRepositoryProvider;

@Service
@NoRepositoryBean
public class JpaVerseRepositoryProvider extends VerseRepositoryProvider<JpaVerseRepository<?, ?>> {

	@Autowired
	public JpaVerseRepositoryProvider(
			JpaBibleVerseRepository jpaBibleVerseRepository,
			JpaKoranVerseRepository jpaKoranVerseRepository,
			JpaMormonVerseRepository jpaMormonVerseRepository,
			JpaOldTestamentVerseRepository jpaOldTestamentVerseRepository) {
		super(jpaBibleVerseRepository, jpaKoranVerseRepository, jpaMormonVerseRepository, jpaOldTestamentVerseRepository);
	}

}
