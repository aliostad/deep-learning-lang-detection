/*
 * Copyright 2000-2011 Enonic AS
 * http://www.enonic.com/license
 */
package com.enonic.vertical.engine;

import org.springframework.beans.factory.InitializingBean;
import org.w3c.dom.Document;

import com.enonic.esl.xml.XMLTool;
import com.enonic.vertical.engine.handlers.CategoryHandler;
import com.enonic.vertical.engine.handlers.CommonHandler;
import com.enonic.vertical.engine.handlers.ContentHandler;
import com.enonic.vertical.engine.handlers.ContentObjectHandler;
import com.enonic.vertical.engine.handlers.GroupHandler;
import com.enonic.vertical.engine.handlers.LanguageHandler;
import com.enonic.vertical.engine.handlers.LogHandler;
import com.enonic.vertical.engine.handlers.MenuHandler;
import com.enonic.vertical.engine.handlers.PageHandler;
import com.enonic.vertical.engine.handlers.PageTemplateHandler;
import com.enonic.vertical.engine.handlers.SectionHandler;
import com.enonic.vertical.engine.handlers.SecurityHandler;
import com.enonic.vertical.engine.handlers.UserHandler;

import com.enonic.cms.domain.content.category.CategoryKey;
import com.enonic.cms.domain.security.user.User;

public class UserServicesEngine
    extends BaseEngine
    implements InitializingBean
{

    private CategoryHandler categoryHandler;

    private CommonHandler commonHandler;

    private ContentHandler contentHandler;

    private ContentObjectHandler contentObjectHandler;

    private GroupHandler groupHandler;

    private LanguageHandler languageHandler;

    private LogHandler logHandler;

    private MenuHandler menuHandler;

    private PageHandler pageHandler;

    private PageTemplateHandler pageTemplateHandler;

    private SectionHandler sectionHandler;

    private SecurityHandler securityHandler;

    private UserHandler userHandler;

    public void setCategoryHandler( CategoryHandler categoryHandler )
    {
        this.categoryHandler = categoryHandler;
    }

    public void setCommonHandler( CommonHandler commonHandler )
    {
        this.commonHandler = commonHandler;
    }

    public void setContentHandler( ContentHandler contentHandler )
    {
        this.contentHandler = contentHandler;
    }

    public void setContentObjectHandler( ContentObjectHandler contentObjectHandler )
    {
        this.contentObjectHandler = contentObjectHandler;
    }

    public void setGroupHandler( GroupHandler groupHandler )
    {
        this.groupHandler = groupHandler;
    }

    public void setLanguageHandler( LanguageHandler languageHandler )
    {
        this.languageHandler = languageHandler;
    }

    public void setLogHandler( LogHandler logHandler )
    {
        this.logHandler = logHandler;
    }

    public void setMenuHandler( MenuHandler menuHandler )
    {
        this.menuHandler = menuHandler;
    }

    public void setPageHandler( PageHandler pageHandler )
    {
        this.pageHandler = pageHandler;
    }

    public void setPageTemplateHandler( PageTemplateHandler pageTemplateHandler )
    {
        this.pageTemplateHandler = pageTemplateHandler;
    }

    public void setSectionHandler( SectionHandler sectionHandler )
    {
        this.sectionHandler = sectionHandler;
    }

    public void setSecurityHandler( SecurityHandler securityHandler )
    {
        this.securityHandler = securityHandler;
    }

    public void setUserHandler( UserHandler userHandler )
    {
        this.userHandler = userHandler;
    }


    public void afterPropertiesSet()
        throws Exception
    {
        init();
    }

    private void init()
    {
        // event listeners
        contentHandler.addListener( logHandler );
        contentHandler.addListener( sectionHandler );
        menuHandler.addListener( logHandler );
    }

    public CategoryHandler getCategoryHandler()
    {
        return categoryHandler;
    }

    public CommonHandler getCommonHandler()
    {
        return commonHandler;
    }

    public ContentHandler getContentHandler()
    {
        return contentHandler;
    }

    public ContentObjectHandler getContentObjectHandler()
    {
        return contentObjectHandler;
    }

    public GroupHandler getGroupHandler()
    {
        return groupHandler;
    }

    public LanguageHandler getLanguageHandler()
    {
        return languageHandler;
    }

    public LogHandler getLogHandler()
    {
        return logHandler;
    }

    public MenuHandler getMenuHandler()
    {
        return menuHandler;
    }

    public PageHandler getPageHandler()
    {
        return pageHandler;
    }

    public PageTemplateHandler getPageTemplateHandler()
    {
        return pageTemplateHandler;
    }

    public SectionHandler getSectionHandler()
    {
        return sectionHandler;
    }

    public SecurityHandler getSecurityHandler()
    {
        return securityHandler;
    }

    public UserHandler getUserHandler()
    {
        return userHandler;
    }

    public String[] createLogEntries( User user, String xmlData )
        throws VerticalCreateException, VerticalSecurityException
    {

        Document doc = XMLTool.domparse( xmlData, new String[]{"logentry", "logentries"} );
        return logHandler.createLogEntries( user, doc );
    }

    public String getContent( User user, int key, boolean publishedOnly, int parentLevel, int childrenLevel, int parentChildrenLevel )
    {

        if ( user == null )
        {
            user = userHandler.getAnonymousUser();
        }

        Document doc =
            contentHandler.getContent( user, key, publishedOnly, parentLevel, childrenLevel, parentChildrenLevel, false, false, null );

        return XMLTool.documentToString( doc );
    }

    public String getCategoryName( int key )
    {
        Document doc = categoryHandler.getCategoryNameDoc( CategoryKey.parse( key ) );
        return XMLTool.documentToString( doc );
    }


    public User getAnonymousUser()
    {
        return userHandler.getAnonymousUser();
    }


    public String getContentTypeByContent( int contentKey )
    {
        int contentTypeKey = contentHandler.getContentTypeKey( contentKey );
        return XMLTool.documentToString( contentHandler.getContentType( contentTypeKey, false ) );
    }

    public String getContentTypeByCategory( int categoryKey )
    {
        int contentTypeKey = categoryHandler.getContentTypeKey( CategoryKey.parse( categoryKey ) );
        return XMLTool.documentToString( contentHandler.getContentType( contentTypeKey, false ) );
    }

    public String getMenuItem( User user, int mikey )
    {
        return XMLTool.documentToString( menuHandler.getMenuItem( user, mikey, false, true, false ) );
    }

    public int getCurrentVersionKey( int contentKey )
    {
        return contentHandler.getCurrentVersionKey( contentKey );
    }

}
