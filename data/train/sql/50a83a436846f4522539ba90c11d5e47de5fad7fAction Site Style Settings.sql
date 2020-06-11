use [ALP.ActionSiteVIC_DEV]
-- use [ALP.ActionSite]

update CE_SiteSettings
set ModuleFontColour = '6A6A6A'
, BackgroundFontColour = 'FF0800'
, BackgroundColour = 'FFFFFF'
, FontTypeFace = 'Verdana'
, ButtonTopGradientColour = '8D8D8D'
, ButtonBottomGradientColour = '555555'
, ModuleTopGradientColour1 = 'FFB502'
, ModuleBottomGradientColour1 = 'FF9C00'
, ModuleTopGradientColour2 = '4FFF84'
, ModuleBottomGradientColour2 = 'FFBE7D'
, NavTopGradientColour = '3C3C3C'
, NavBottomGradientColour = '3C3C3C'
, NavFontColour1 = 'FFFFFF'
, NavFontColour2 = '3C3C3C'
, NavOnColour = 'FFFFFF'
, ModuleBackgroundColour = 'EFEFEF'
, ButtonFontColour = 'FFFFFF'
, PageBackground = 'FFFFFF'
, CustomModuleFontColour = '6A6A6A'
where SiteID in (select siteid from CMS_Site where SiteName = 'mghtest')

select s.SiteName, ss.* from CMS_Site s inner join CE_SiteSettings ss on s.SiteID = ss.SiteID
where s.SiteName in ('ALPActionDevSite', 'peymandev', 'mghdev', 'mghtest')

