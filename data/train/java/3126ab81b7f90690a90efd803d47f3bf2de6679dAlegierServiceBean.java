package model.services;

import javax.inject.Inject;

/**
 * Created by Wojtek on 2014-09-28.
 */
public class AlegierServiceBean {

    private ItemService itemService;
    private CategoryService categoryService;
    private AccountService accountService;

    public ItemService getItemService()
    {
        return this.itemService;
    }

    @Inject
    public void setItemService( ItemService itemService )
    {
        this.itemService = itemService;
    }


    public CategoryService getCategoryService()
    {
        return this.categoryService;
    }

    @Inject
    public void setCategoryService( CategoryService categoryService )
    {
        this.categoryService = categoryService;
    }




    public AccountService getAccountService()
    {
        return this.accountService;
    }

    @Inject
    public void setAccountService( AccountService accountService )
    {
        this.accountService = accountService;
    }

}

