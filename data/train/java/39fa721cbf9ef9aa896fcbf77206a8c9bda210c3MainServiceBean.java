package model.service;

import javax.inject.Inject;

/**
 * Created by w.maciejewski on 2014-09-29.
 */
public class MainServiceBean
{


    private AccountService accountService;
    private CategoryService categoryService;
    private OfferService offerService;

    public AccountService getAccountService()
    {
        return this.accountService;
    }

    @Inject
    public void setAccountService( AccountService accountService )
    {
        this.accountService = accountService;
    }

    public CategoryService getCategoryService() {
        return categoryService;
    }
    @Inject
    public void setCategoryService(CategoryService categoryService) {
        this.categoryService = categoryService;
    }


	public OfferService getOfferService() {
		return offerService;
	}

    @Inject
    public void setOfferService( OfferService offerService ) { this.offerService=offerService;}
}
