CREATE TABLE dbo.Customer
    (
      [CustomerId] INT NOT NULL
                       IDENTITY(10000, 1) ,
      [CustomerNumber] VARCHAR(15) NOT NULL ,
      [CustomerName] NVARCHAR(100) NOT NULL ,
      [CreateDate] DATETIME NOT NULL ,
      [PasswordHash] VARBINARY(40) NULL ,
      [LastLoginDate] DATETIME NULL ,
      CONSTRAINT PK_CustomerId PRIMARY KEY CLUSTERED ( CustomerId )
    )
GO


CREATE TABLE dbo.Visitor
    (
      [VisitorId] UNIQUEIDENTIFIER NOT NULL ,
      [ZipCode] VARCHAR(20) NULL ,
      [CustomerNumber] VARCHAR(20) NULL ,
      [LastBasketId] INT NULL ,
      [CountryCode] VARCHAR(5) ,
      [CreateDate] DATETIME NOT NULL ,
      CONSTRAINT PK_VisitorId PRIMARY KEY CLUSTERED ( VisitorId )
    )
GO	


CREATE TABLE dbo.Category
    (
      CategoryId INT IDENTITY(1, 1) ,
      CategoryName NVARCHAR(50) NOT NULL ,
      CreateDate DATETIME NOT NULL ,
      ImageUrl VARCHAR(200) NULL ,
      LinkUrl VARCHAR(500) NULL ,
      DisplayTitle VARCHAR(500) NULL ,
      CONSTRAINT PK_CategoryId PRIMARY KEY CLUSTERED ( CategoryId )
    )
GO

CREATE TABLE dbo.Product
    (
      [ProductId] INT IDENTITY(1, 1)
                      NOT NULL ,
      [Status] CHAR(1) NULL ,
      [TemplateId] INT NULL ,
      [CategoryId] INT NULL ,
      [ProductName] VARCHAR(100) NULL ,
      [ShortName] VARCHAR(75) NULL ,
      [BrandCode] VARCHAR(50) NULL ,
      [BrandName] VARCHAR(50) NULL ,
      [CreateDate] DATETIME NOT NULL ,
      CONSTRAINT PK_ProductId PRIMARY KEY CLUSTERED ( ProductId ) ,
      CONSTRAINT FK_Category_Product_CategoryId FOREIGN KEY ( CategoryId ) REFERENCES dbo.Category ( CategoryId )
    )
GO

CREATE TABLE dbo.Sku
    (
      [SkuCode] VARCHAR(30) NOT NULL ,
      [ProductId] INT NULL ,
      [Status] CHAR(1) NULL ,
      [ImageUrl] INT NULL ,
      [ItemDesc] VARCHAR(500) NULL ,
      [RetailPrice] DECIMAL(18, 2) NULL ,
      [CreateDate] DATETIME NOT NULL ,
      [OptionAttrName1] VARCHAR(30) NULL ,
      [OptionAttrValue1] VARCHAR(300) NULL ,
      [OptionAttrName2] VARCHAR(30) NULL ,
      [OptionAttrValue2] VARCHAR(300) NULL ,
      CONSTRAINT PK_SkuCode PRIMARY KEY CLUSTERED ( SkuCode ) ,
      CONSTRAINT FK_Product_Sku_ProductId FOREIGN KEY ( ProductId ) REFERENCES dbo.Product ( ProductId )
    )
GO


CREATE TABLE dbo.Basket
    (
      [BasketId] INT NOT NULL
                     IDENTITY(100000, 1) ,
      [CustomerNumber] VARCHAR(15) NULL ,
      [TotalAmount] DECIMAL(18, 2) NULL ,
      [Discount] DECIMAL(18, 2) NULL ,
      [CreateDate] DATETIME NOT NULL ,
      [UpdateDate] DATETIME NULL ,
      [Notes] VARCHAR(255) NULL ,
      [IsPlaced] CHAR(1) NULL
                         DEFAULT ( 'N' ) ,
      CONSTRAINT PK_BasketId PRIMARY KEY CLUSTERED ( BasketId )
    )
	GO

CREATE TABLE dbo.BasketItem
    (
      [BasketItemId] INT NOT NULL
                         IDENTITY(1, 1) ,
      [BasketId] INT NOT NULL ,
      [Sku] VARCHAR(30) NOT NULL ,
      [ProductId] INT NOT NULL ,
      [Quantity] INT NOT NULL ,
      [Discount] DECIMAL(18, 3) NULL ,
      [SubTotal] DECIMAL(18, 3) NOT NULL ,
      [CreateDate] DATETIME NOT NULL ,
      [UpdateDate] DATETIME NULL ,
      CONSTRAINT PK_BasketItemId PRIMARY KEY CLUSTERED ( BasketItemId ) ,
      CONSTRAINT FK_BasketItem_Basket_BasketId FOREIGN KEY ( BasketId ) REFERENCES dbo.Basket ( BasketId )
    )
GO


CREATE TABLE [dbo].[TopMenu]
    (
      [TopMenuId] INT NOT NULL
                      IDENTITY(1, 1) ,
      [MenuName] VARCHAR(100) NOT NULL ,
      [DisplayOrder] INT NOT NULL ,
      [ImageName] VARCHAR(100) NULL ,
      [IsShowOnTop] CHAR(1) NULL ,
      [CreateDate] DATETIME NOT NULL ,
      [UpdateDate] DATETIME NULL ,
      [MenuUrl] VARCHAR(255) ,
      CONSTRAINT PK_TopMenuId PRIMARY KEY CLUSTERED ( TopMenuId )
    ) 
GO

CREATE TABLE [dbo].[MenuNavigation]
    (
      [NavigationId] INT NOT NULL ,
      [NavigationName] VARCHAR(100) NOT NULL ,
      [NavigationLogo] VARCHAR(100) NULL ,
      [ImageName] VARCHAR(100) NULL ,
      [DisplayOrder] INT NULL ,
      [CreateDate] DATETIME NULL ,
      [UpdateDate] DATETIME NULL ,
      CONSTRAINT PK_NavigationId PRIMARY KEY CLUSTERED ( NavigationId )
    ) 
GO

CREATE TABLE [dbo].[TopMenuNavMapping]
    (
      [TopMenuId] INT NOT NULL ,
      [MappingId] INT NOT NULL
                      IDENTITY(1, 1) ,
      [NavigationId] INT
        NOT NULL ,
        CONSTRAINT PK_TopMenuNavMappingId PRIMARY KEY CLUSTERED ( MappingId ),
		CONSTRAINT FK_TopMenuNavMapping_TopMenu FOREIGN KEY ( TopMenuId ) REFERENCES dbo.TopMenu ( TopMenuId ),
		CONSTRAINT FK_TopMenuNavMapping_MenuNavigation FOREIGN KEY ( NavigationId ) REFERENCES MenuNavigation ( NavigationId )
    ) 
GO

CREATE TABLE [dbo].[ProductNavigation]
    (
      [NavigationId] INT NOT NULL ,
      [NavigationName] VARCHAR(50) NULL ,
      [DisplayOrder] INT NULL ,
      [URL] VARCHAR(150) NULL ,
      [NavigationDesc] VARCHAR(255) NULL ,
      [ImageName] VARCHAR(100) NULL ,
      [NavigationLogo] VARCHAR(100) NULL ,
      [Display] CHAR(1) NULL ,
      [CreateDate] DATETIME NULL ,
      [CreateBy] VARCHAR(30) NULL ,
      [UpdateDate] DATETIME NULL ,
      [UpdateBy] VARCHAR(30) NULL ,
      CONSTRAINT PK_Product_NavigationId PRIMARY KEY CLUSTERED
        ( NavigationId )
    )
GO


CREATE TABLE [dbo].[MenuProductNavMapping]
    (
      [MappingId] INT NOT NULL
                      IDENTITY(1, 1) ,
      [MenuNavigationId] INT NOT NULL,
	  [ProductNavigation] INT NOT NULL,
        CONSTRAINT PK_MenuProductNavMappingId PRIMARY KEY CLUSTERED ( MappingId ),
		CONSTRAINT FK_MenuProductNavMapping_ProductNavigation FOREIGN KEY ( ProductNavigation ) REFERENCES dbo.ProductNavigation ( NavigationId ),
		CONSTRAINT FK_MenuProductNavMapping_MenuNavigation FOREIGN KEY ( MenuNavigationId ) REFERENCES MenuNavigation ( NavigationId )
    ) 
GO