package com.opencms.core.db.service.impl;

import com.opencms.core.db.service.*;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created by IntelliJ IDEA.
 * User: Lij
 * Date: 2010-12-5
 * Time: 8:25:22
 * To change this template use File | Settings | File Templates.
 */
@Service
public class CmsManagerImpl implements CmsManager {

    @Resource
    private UserService userService;

    @Resource
    private ContentService contentService;

    @Resource
    private SiteService siteService;

    @Resource
    private CategoryService categoryService;

    public UserService getUserService() {
        return userService;
    }

    public ContentService getContentService() {
        return contentService;
    }

    public SiteService getSiteService() {
        return siteService;
    }

    public CategoryService getCategoryService() {
        return categoryService;
    }
}
