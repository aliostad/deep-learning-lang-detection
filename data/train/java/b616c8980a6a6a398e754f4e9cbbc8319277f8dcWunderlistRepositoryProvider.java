package ru.ilyamodder.mynotes.data.repository;

/**
 * @author ilya
 */

public class WunderlistRepositoryProvider {

    private static WunderlistRepository sRepository;

    public static WunderlistRepository provideAuthorizationRepository() {
        if (sRepository == null) {
            sRepository = new WunderlistRepositoryImpl();
        }
        return sRepository;
    }

    public static void setsRepository(WunderlistRepository sRepository) {
        WunderlistRepositoryProvider.sRepository = sRepository;
    }
}
