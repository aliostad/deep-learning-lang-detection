USE [master]
GO
/****** Object:  Login [Async_login]    Script Date: 23/07/2013 10:33:23 ******/
DROP LOGIN [NewUrls2_login]
GO
USE [NewUrls2]
GO
ALTER DATABASE NewUrls2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
DROP DATABASE [NewUrls2]
GO


