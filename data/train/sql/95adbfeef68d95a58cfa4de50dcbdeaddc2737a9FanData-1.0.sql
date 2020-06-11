/*******************************************************************************
  Fan Database Data - v1.0
  DB Server: SqlServer, SqlAzure
  Author: Ray Fan
********************************************************************************/

/* App ---------------------------------------------------------------------- */

INSERT INTO [dbo].[Fan_App] VALUES('Blog', 'b', 1, 2, 'Ray Fan', '1.0', 'A blog app that allows you to post articles, photo galleries etc.')
GO
INSERT INTO [dbo].[Fan_App] VALUES('Calculator', NULL, 0, 0, 'DrABELL', '5.0', 'A calculator app')
GO

/* Nav ---------------------------------------------------------------------- */

INSERT INTO [dbo].[Fan_Nav] VALUES('Technology and Programming', 'tech', 'A tech and programming blog',  GETUTCDATE(), 1, 1)
GO
INSERT INTO [dbo].[Fan_Nav] VALUES('Living', 'living', 'My blog on daily life',  GETUTCDATE(), 1, 1)
GO

/* Frontpage ---------------------------------------------------------------- */

INSERT INTO [dbo].[Fan_Obj] ( [NavId], [Key], [Format], [Data] )
VALUES  ( 1, -- SITE_NAVID
          'site-frontpage', -- Site_FrontPage_ObjKey
          3, -- Format Html
N'<div class="row">
  <div class="span6">
    <h3>
      Blogs    
    </h3>
    <a href="/tech" class="tile" style="background-color: #F06421">
      <span class="app-label">
        Technology and Programming      
      </span>
    </a>
    <a href="/living" class="tile" style="background-color: purple">
      <span class="app-label">
        Living      
      </span>
    </a>
  </div>
</div>
<br />
<div class="row">
  <div class="span6">
    <ul style="list-style:square">
      <li>
        Login with "admin", "admin123"
      </li>
      <li>
        Change username/password and/or create new user in Admin Panel
      </li>
      <li>
        Come back edit this page and remove this content
      </li>
      <li>
        Nav an app here
      </li>
    </ul>
  </div>
</div>
'  -- Data
)
GO
          
/* User --------------------------------------------------------------------- */

INSERT INTO [dbo].[Fan_User] ([UserName], [Email], [AccountStatus], [DisplayName], [Language], [TZone], [Bio]) 
VALUES(N'anonymous',N'anonymous@notset.com', 1, N'anonymous', 0, N'Pacific Standard Time', N'The anonymous user.')
GO

INSERT INTO [dbo].[Fan_User] ([UserName], [Email], [AccountStatus], [DisplayName], [Language], [TZone], [Bio]) 
VALUES (N'admin', N'admin@notset.com', 1, N'admin', 0, N'Pacific Standard Time', N'The admin user.');
GO

-- NOTE: the [webpages_Membership] does not have IDENTITY on the PK
INSERT INTO [dbo].[webpages_Membership] 
VALUES (0, GETUTCDATE(),NULL,1,NULL,0,N'',GETUTCDATE(),N'',NULL,NULL);
GO

INSERT INTO [dbo].[webpages_Membership] 
VALUES (1, GETUTCDATE(),NULL,1,NULL,0,N'AEFlg/BdxOi2ncQXEXrsnDimqRsMVapW6SYYGoq6PWi+/OPuwjg0mRLXVJykwL3GuA==',GETUTCDATE(),N'',NULL,NULL);
GO

/* Post --------------------------------------------------------------------- */

INSERT INTO [dbo].[Blog_Post]
     VALUES
           (NEWID() --<PostGuidId, uniqueidentifier,>
           ,1 --<NavId, int,>
           ,0 --<PostType, smallint,>
           ,1 --<PostStatus, smallint,>
           ,1 --<UserId, int,>
           ,'welcome-to-fan' --<Slug, nvarchar(256),>
           ,'Welcome to Fan' --<Subject, nvarchar(256),>
           ,N'<div class="row">
    <div class="span4">
        <h3>You Control the URL</h3>
        <p>http://yoursite.com/{<b>you-specify</b>}</p>
    </div>
    <div class="span4">
        <h3>Apps</h3>
        <p>The "<b>you-specify</b>" is mapped to an app</p>		
    </div>		
</div>

<div class="row">
    <div class="span6">
      <h3>Some Possible Senarios</h3>
      <p>I am a small company, I just need a blog and want it to be at http://mycompany.com/blog. Go create a nav with a slug "blog" and Blog App.</p>
      <p>I am passionate about both technology and cooking, want to blog about both yet keep them separate. Then http://mysite.com/technology and http://mysite.com/cooking will do it.</p>		
    </div>
</div>

<div class="row">
    <div class="span6">
      <h3>More Power with HTML & Bootstrap Directly</h3>
      <p>With Fan, you work with html & bootstrap, the result is what html, bootstrap and your imagination allow you do.</p>
    </div>
</div>' --<Body, nvarchar(max),>
           ,'2013/1/30 04:38:12.892'--<DateCreated, datetime2(7),>
           ,'2013/1/30 04:38:12.892' --<DateUpdated, datetime2(7),>
           ,0  --<ViewCount, int,>
           ,'000.000.000.000' --<IP, nvarchar(64),>
           ,0 -- IsIndexed
)
GO

/* Archive --------------------------------------------------------------------- */

INSERT INTO [dbo].[Blog_Archive]
     VALUES
           (
           1 --<NavId, int,>
           , 2013 --<Year, int,>
           ,1 --<M01, int,>
           ,0 --<M02, int,>
           ,0 --<M03, int,>
           ,0 --<M04, int,>
           ,0 --<M05, int,>
           ,0 --<M06, int,>
           ,0 --<M07, int,>
           ,0 --<M08, int,>
           ,0 --<M09, int,>
           ,0 --<M10, int,>
           ,0 --<M11, int,>
           ,0 --<M12, int,>
           )
GO