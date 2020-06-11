package de.andre.repository.catalog;

import de.andre.repository.RepositoryAdapter;

public class PricesRepository extends RepositoryAdapter {
    private final PriceRepository priceRepository;
    private final PriceListRepository priceListRepository;

    public PricesRepository(final PriceRepository priceRepository,
            final PriceListRepository priceListRepository) {
        super(priceListRepository, priceRepository);
        this.priceRepository = priceRepository;
        this.priceListRepository = priceListRepository;
    }

    public PriceListRepository getPriceListRepository() {
        return priceListRepository;
    }

    public PriceRepository getPriceRepository() {
        return priceRepository;
    }
}
