package free.solnRss.singleton;


import android.content.Context;
import free.solnRss.repository.PublicationRepository;


public class PublicationRepositorySingleton {

	private static PublicationRepositorySingleton	instance;
	protected PublicationRepository					repository;

	public PublicationRepositorySingleton(final Context context) {
		repository = new PublicationRepository(context);
	}

	public static PublicationRepositorySingleton getInstance(final Context context) {
		if (instance == null) {
			instance = new PublicationRepositorySingleton(context);
		}
		return instance;
	}

	public PublicationRepository getPublicationRepository() {
		return repository;
	}
}
