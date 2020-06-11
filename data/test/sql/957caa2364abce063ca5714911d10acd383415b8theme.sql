-- ==========================================================
-- GUI THEMING
-- 
-- This file contains settings associated with the theme
-- for the GUI.
-- ==========================================================

-- The main tab alignment (north or west)
INSERT INTO Settings (key,value) VALUES('theme.main_tab_alignment', 'north');

-- Whether or not the toolbar is visible
INSERT INTO Settings (key,value) VALUES('theme.has_toolbar', '1');

-- Whether or not the menu bar is visible
INSERT INTO Settings (key,value) VALUES('theme.has_menubar', '1');

-- Whether or not the status bar is visible
INSERT INTO Settings (key,value) VALUES('theme.has_statusbar', '1');

-- The top level stylesheet of of the application. This can
-- be customized in the per-tab stylesheet
INSERT INTO Settings (key,value) VALUES('theme.main_content_stylesheet', '
QToolBar
{
    border:0px solid #ddd;
    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:1 #bbb, stop:0 #eee);
    min-height:40px;
    
}

QWidget#toolbar_background QLabel#m_page_label
{
    color:#766b57;
}
QWidget#nav_bar QPushButton#left
{
    border:1px solid #666;
    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #697174, stop:1.0 #3b3f42);
    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #5d6a80, stop:1.0 #343d4c);
    border-top-left-radius:4px;
    border-bottom-left-radius:4px;
    border-right:0px;
}
QWidget#nav_bar QPushButton#right
{
    border:1px solid #666;
    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #697174, stop:1.0 #3b3f42);
    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #5d6a80, stop:1.0 #343d4c);
    border-top-right-radius:4px;
    border-bottom-right-radius:4px;
    border-left:0px;
}

QWidget#nav_bar
{
    background: #555;
    background: url(:/images/resources/toolbar_background.png) repeat-x;
    border:1px solid #999;
    border-radius:4px;
    margin:4px;
}
QWidget#nav_bar QPushButton
{
    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #5d6a80, stop:1.0 #343d4c);
    border:1px solid #666;
    border-left:1px solid #666;
    border-right:0px;
    margin:0px;
    padding:4px;
    color:white;
    font-weight:bold;
    min-height:22px;
}

QWidget#nav_bar QPushButton:checked
{
    border-top:1px solid #d0d0d0;
    border-bottom:1px solid #d0d0d0;
    border-right:1px solid #d0d0d0;
    border-left:0px solid #d0d0d0;
    padding:4px;
    margin:0px;
    background:white;
    color:#766b57;
}

QWidget#nav_bar QPushButton:hover
{
    border-top:1px solid #666;
    border-bottom:1px solid #666;
    border-right:1px solid #666;
    border-left:0px solid #666;
    padding:4px;
    margin:0px;
    color:black;
}

QWidget#nav_bar QPushButton:disabled
{
    border-top:1px solid #666;
    border-bottom:1px solid #666;
    border-right:1px solid #666;
    border-left:0px solid #666;
    padding:4px;
    margin:0px;
    color:#666;
}

QWidget#nav_bar QPushButton#spacer
{
    border:1px solid #666;
    border-right:0px;
    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #697174, stop:1.0 #3b3f42);
    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #5d6a80, stop:1.0 #343d4c);
}
QWidget#nav_bar QPushButton:focus:pressed
{
    border-top:1px solid #d0d0d0;
    border-bottom:1px solid #d0d0d0;
    border-right:1px solid #d0d0d0;
    border-left:0px solid #d0d0d0;
    padding:4px;
    background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #b0b0b0, stop: 0.5 #FeF7F7, stop:1.0 #b0b0b0);
    color:black;
}
QWidget#nav_bar QPushButton:hover
{
    border-top:1px solid #d0d0d0;
    border-bottom:1px solid #d0d0d0;
    border-right:1px solid #d0d0d0;
    border-left:0px solid #d0d0d0;
    padding:4px;
    color:black;
    background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #d0d0d0, stop: 0.5 #FeF7F7, stop:1.0 #d0d0d0);
}


QWidget#nav_bar QComboBox
{    
    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #5d6a80, stop:1.0 #343d4c);
    border:1px solid #666;
    border-left:1px solid #666;
    border-right:0px;
    margin:0px;
    padding:4px;
    color:white;
    font-weight:bold;
    min-height:22px;
}

QWidget#nav_bar QCheckBox
{    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #5d6a80, stop:1.0 #343d4c);
    border:1px solid #666;
    border-left:1px solid #666;
    border-right:0px;
    margin:0px;
    padding:4px;
    color:white;
    font-weight:bold;
    min-height:22px;
}
QWidget#nav_bar QCheckBox:disabled
{   
    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #5d6a80, stop:1.0 #343d4c);
    border:1px solid #666;
    border-left:1px solid #666;
    border-right:0px;
    margin:0px;
    padding:4px;
    color:#666;
    font-weight:bold;
    min-height:22px;
}

QWidget#nav_bar QLabel
{    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #5d6a80, stop:1.0 #343d4c);
    border:1px solid #666;
    border-left:1px solid #666;
    border-right:0px;
    margin:0px;
    padding:4px;
    color:white;
    font-weight:bold;
    min-height:22px;
}

QWidget#nav_bar QPushButton#spacer_right
{    
    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #5d6a80, stop:1.0 #343d4c);
    border:1px solid #666;
    margin:0px;
    padding:4px;
    color:white;
    font-weight:bold;
    min-height:22px;
}

QWidget#nav_bar QPushButton#spacer_left
{    
    background: qlineargradient(spread:pad, x1:0, y1:0, x2:0, y2:1, stop:0 #5d6a80, stop:1.0 #343d4c);
    border:1px solid #666;
    margin:0px;
    padding:4px;
    color:white;
    font-weight:bold;
    min-height:22px;
}

QWidget#toolbar_background
{
    background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #aebaca, stop:1.0 #5b6b82);
    background: white;
    border-radius: 4px;
    border:1px solid #ccc;
}


    
QTabWidget#m_tabs::pane { /* The tab widget frame */
  border-top: 1px solid #C2C7CB;
  background:#eee;
}
QTabWidget#m_tabs::tab-bar {
  left: 10px; /* move to the right by 5px */
}
QTabWidget#m_tabs > QTabBar
{
    background:transparent;
}
QWidget#WidgetEditor
{
    background: url(:/images/resources/tabs_background.png) repeat-x;
}
QWidget#m_tabs
{
    background:#eee;
    border:0px;
    border-bottom:1px solid #999;
}

QStatusBar
{
    background: url(:/images/resources/tabs_background.png) repeat-x;
    min-height:24px;
    color:white;
}
QStatusBar::item
{
    border:0px;
    color:white;
    margin-left:10px;
}

QStatusBar QLabel
{
    color: white;
    margin-left:10px;
}


QTabBar::tab {
  margin-top:2px;
  background:#fff;
  border: 1px solid #C4C4C3;
  border-bottom:0px;
  border-bottom-color: #C2C7CB; /* same as the pane color */
  border-top-left-radius: 4px;
  border-top-right-radius: 4px;
  min-width: 8px;
  padding: 4px;
  margin-left:1px;
  color: black;
}

QTabBar::tab:selected, QTabBar::tab:hover  {
  margin-top:2px;
  background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #fafafa, stop: 0.4 #f4f4f4, stop: 0.5 #e7e7e7, stop: 1.0 #fafafa);
  border-color: #9B9B9B;
  border-bottom-color: #C2C7CB; /* same as pane color */
}
QTabWidget QTabBar::tab:selected {
  margin-top:2px;
  border-color: #9B9B9B;
  border-bottom-color: #C2C7CB; /* same as pane color */
}
QTabBar::tab:!selected {
  margin-top:2px;
}
');
    

-- This is the stylesheet applied to the contents of each tab. This
-- allows it to be styled differently than the top level tab.
INSERT INTO Settings (key,value) VALUES('theme.main_tab_content_stylesheet', '
QTabBar::tab {
  margin-top:2px;
  background:#fff;
  border: 1px solid #C4C4C3;
  border-bottom:0px;
  border-bottom-color: #C2C7CB; /* same as the pane color */
  border-top-left-radius: 4px;
  border-top-right-radius: 4px;
  min-width: 8px;
  padding: 4px;
  margin-left:1px;
  color: black;
}

QTabBar::tab:selected, QTabBar::tab:hover  {
  margin-top:2px;
  background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #fafafa, stop: 0.4 #f4f4f4, stop: 0.5 #e7e7e7, stop: 1.0 #fafafa);
  border-color: #9B9B9B;
  border-bottom-color: #C2C7CB; /* same as pane color */
}
QTabWidget QTabBar::tab:selected {
  margin-top:2px;
  border-color: #9B9B9B;
  border-bottom-color: #C2C7CB; /* same as pane color */
}
QTabBar::tab:!selected {
  margin-top:2px;
}

');
