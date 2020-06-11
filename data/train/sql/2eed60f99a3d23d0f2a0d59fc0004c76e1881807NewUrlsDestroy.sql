USE [master]
GO
/****** Object:  Login [Async_login]    Script Date: 23/07/2013 10:33:23 ******/
DROP LOGIN [NewUrls_login]
GO
USE [NewUrls]
GO
ALTER DATABASE NewUrls SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
DROP DATABASE [NewUrls]
GO


