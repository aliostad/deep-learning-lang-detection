package madvirus.spring.chap04.article;

import org.springframework.beans.factory.annotation.Autowired;

public class ArticleServiceImpl implements ArticleService {

	@Autowired
	private ArticleRepository repository;

	public ArticleServiceImpl() {
	}
	
	public ArticleServiceImpl(ArticleRepository repository) {
		this.repository = repository;
	}

	@Override
	public void writeArticle(String title, String content) {
		System.out.println("ArticleServiceImpl.writeArticle()");
		repository.save(new Article(title, content));
	}

	public void setRepository(ArticleRepository repository) {
		this.repository = repository;
	}

}
