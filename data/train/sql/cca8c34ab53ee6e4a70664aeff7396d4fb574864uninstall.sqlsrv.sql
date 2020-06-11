SET QUOTED_IDENTIFIER ON;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[#__imageshow_theme_classic_flash]') AND type in (N'U'))
BEGIN
DROP TABLE #__imageshow_theme_classic_flash
END;

SET QUOTED_IDENTIFIER ON;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[#__imageshow_theme_classic_parameters]') AND type in (N'U'))
BEGIN
DROP TABLE #__imageshow_theme_classic_parameters
END;

SET QUOTED_IDENTIFIER ON;
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[#__imageshow_theme_classic_javascript]') AND type in (N'U'))
BEGIN
DROP TABLE #__imageshow_theme_classic_javascript
END;