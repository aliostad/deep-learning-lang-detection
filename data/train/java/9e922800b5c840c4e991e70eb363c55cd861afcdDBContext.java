package org.gp.spyder;

import org.gp.spyder.repositories.ImageRepository;
import org.gp.spyder.repositories.WebPageRepository;

public class DBContext {

	private WebPageRepository webPageRepository;
	private ImageRepository imageRepository;

	public DBContext(WebPageRepository webPageRepository,
			ImageRepository imageRepository) {
		super();
		this.webPageRepository = webPageRepository;
		this.imageRepository = imageRepository;
	}

	public WebPageRepository getWebPageRepository() {
		return webPageRepository;
	}

	public void setWebPageRepository(WebPageRepository webPageRepository) {
		this.webPageRepository = webPageRepository;
	}

	public ImageRepository getImageRepository() {
		return imageRepository;
	}

	public void setImageRepository(ImageRepository imageRepository) {
		this.imageRepository = imageRepository;
	}

}
