CREATE TABLE [dbo].[n_customer] (
    [customer_id]         INT            IDENTITY (1, 1) NOT NULL,
    [customer_name]       NVARCHAR (50)  NOT NULL,
    [customer_tel]        VARCHAR (11)   NOT NULL,
    [customer_tel_append] VARCHAR (50)   NULL,
    [customer_category]   INT            NOT NULL,
    [customer_source]     INT            DEFAULT ((0)) NOT NULL,
    [customer_remarks]    NVARCHAR (500) NULL,
    [customer_level]      INT            DEFAULT ((0)) NOT NULL,
    [customer_paytype]    INT            DEFAULT ((0)) NOT NULL,
    [city_ids]            VARCHAR (200)  NULL,
    [city_names]          NVARCHAR (200) NULL,
    [area_ids]            VARCHAR (200)  NULL,
    [area_names]          NVARCHAR (200) NULL,
    [estate_ids]          VARCHAR (200)  NULL,
    [estate_names]        NVARCHAR (200) NULL,
    [price]               INT            NULL,
    [acreage]             INT            NULL,
    [room]                INT            NULL,
    [customer_isself]     INT            DEFAULT ((2)) NOT NULL,
    [customer_dltflag]    INT            DEFAULT ((0)) NOT NULL,
    [follow_newstatus]    INT            NULL,
    [follow_newsdate]     DATETIME       NULL,
    [seehousing_count]    INT            NULL,
    [owner_userid]        INT            NULL,
    [owner_username]      NVARCHAR (20)  NULL,
    [owner_deptid]        INT            NULL,
    [owner_deptname]      NVARCHAR (20)  NULL,
    [owner_date]          DATETIME       NULL,
    [add_userid]          INT            NOT NULL,
    [add_username]        NVARCHAR (20)  NOT NULL,
    [add_deptid]          INT            NOT NULL,
    [add_deptname]        NVARCHAR (20)  NOT NULL,
    [add_date]            DATETIME       NOT NULL,
    [modify_userid]       INT            NULL,
    [modify_username]     NVARCHAR (20)  NULL,
    [modify_deptid]       INT            NULL,
    [modify_deptname]     NVARCHAR (20)  NULL,
    [modify_date]         DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([customer_id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_n_customer_tel]
    ON [dbo].[n_customer]([customer_tel] ASC);

