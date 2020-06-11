CREATE TABLE IF NOT EXISTS assessment_site_history (
    id int NOT NULL auto_increment, 
    baseurl varchar(255) NOT NULL,
    date_added datetime,
    total_pages int,
    total_html_errors int,
    total_accessibility_errors int,
    total_current_template_html int,
    total_current_template_dep int,
    max_primary_nav_count int,
    total_grid_2006_pages int,
    total_ga_non_async_pages int,
    total_ga_setallowhash_pages int,
    total_links_404 int,
    total_links_301 int,
    
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1; 