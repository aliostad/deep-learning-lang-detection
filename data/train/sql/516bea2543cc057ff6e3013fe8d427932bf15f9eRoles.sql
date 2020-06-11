print 'Insert Roles'
GO

SET IDENTITY_INSERT [Roles] ON

INSERT INTO [Roles]
    ([RoleId]   ,[Name]          ,[Permissions]                                      ,[IsActive],[Version])
VALUES
    (1          ,N'Системен администратор','sys#admin,building#read,building#change,building#delete',1         ,DEFAULT  ),
    (2          ,N'Администратор заведения','building#read,building#change,building#delete',1         ,DEFAULT  ),
    (3          ,N'Оператор заведения','building#read,building#change',1         ,DEFAULT  ),
    (4          ,N'Потребител','building#read',1         ,DEFAULT  )

SET IDENTITY_INSERT [Roles] OFF
GO