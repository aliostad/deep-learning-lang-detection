package messageSystem;

import base.AccountService;
import base.SearchService;

public class AddressService {

    private Address accountService;
    private Address searchService;

    public void registerAccountService(AccountService accountService) {
        this.accountService = accountService.getAddress();
    }

    public void registerSearchService(SearchService searchService) {
        this.searchService = searchService.getAddress();
    }

    public Address getAccountServiceAddress() {
        return accountService;
    }
    public Address getSearchService() { return searchService;}
}
