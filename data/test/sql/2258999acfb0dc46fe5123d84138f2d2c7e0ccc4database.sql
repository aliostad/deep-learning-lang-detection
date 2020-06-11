-- ********************************************************
-- *                                                      *
-- * IMPORTANT NOTE                                       *
-- *                                                      *
-- * Do not import this file manually but use the Contao  *
-- * install tool to create and maintain database tables! *
-- *                                                      *
-- ********************************************************


-- --------------------------------------------------------

--
-- Table `tl_content`
--

CREATE TABLE `tl_content` (
    `si_containerId` varchar(255) NOT NULL default '',
    `si_children` varchar(255) NOT NULL default '',
    `si_itemsVisible` varchar(32) NOT NULL default '',
    `si_elementsSlide` varchar(32) NOT NULL default '',
    `si_itemsSelector` varchar(255) NOT NULL default '',
    `si_responsive` char(1) NOT NULL default '',
    `si_elementDirection` char(1) NOT NULL default '',
    `si_verticalSlide` char(1) NOT NULL default '',
    `si_duration` varchar(255) NOT NULL default '',
    `si_startIndex` varchar(32) NOT NULL default '',
    `si_autoEffectTransition` char(1) NOT NULL default '',
    `si_effectTransition` varchar(255) NOT NULL default '',
    `si_effectEase` varchar(255) NOT NULL default '',
    `si_autoSlide` varchar(64) NOT NULL default '',
    `si_autoSlideDefault` char(1) NOT NULL default '',
    `si_templateDefault` char(1) NOT NULL default '',
    `si_itemsDimension` varchar(255) NOT NULL default '',
    `si_itemsMargin` blob NULL,
    `si_cssTemplate` varchar(255) NOT NULL default '',
    `si_showControls` char(1) NOT NULL default '',
    `si_mouseWheelNav` char(1) NOT NULL default '',
    `si_showBullets` char(1) NOT NULL default '',
    `si_skipInlineStyles` char(1) NOT NULL default '',
    `si_skipNavSize` char(1) NOT NULL default '',
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table `tl_module`
--

CREATE TABLE `tl_module` (
    `si_includeElements` blob NULL,
    `si_itemsVisible` varchar(32) NOT NULL default '',
    `si_elementsSlide` varchar(32) NOT NULL default '',
    `si_itemsSelector` varchar(255) NOT NULL default '',
    `si_responsive` char(1) NOT NULL default '',
    `si_elementDirection` char(1) NOT NULL default '',
    `si_verticalSlide` char(1) NOT NULL default '',
    `si_duration` varchar(255) NOT NULL default '',
    `si_startIndex` varchar(32) NOT NULL default '',
    `si_autoEffectTransition` char(1) NOT NULL default '',
    `si_effectTransition` varchar(255) NOT NULL default '',
    `si_effectEase` varchar(255) NOT NULL default '',
    `si_autoSlide` varchar(64) NOT NULL default '',
    `si_autoSlideDefault` char(1) NOT NULL default '',
    `si_templateDefault` char(1) NOT NULL default '',
    `si_itemsDimension` varchar(255) NOT NULL default '',
    `si_itemsMargin` blob NULL,
    `si_cssTemplate` varchar(255) NOT NULL default '',
    `si_showControls` char(1) NOT NULL default '',
    `si_mouseWheelNav` char(1) NOT NULL default '',
    `si_showBullets` char(1) NOT NULL default '',
    `si_skipInlineStyles` char(1) NOT NULL default '',
    `si_skipNavSize` char(1) NOT NULL default '',
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
