--
--	SourceForge: Breaking Down the Barriers to Open Source Development
--	Copyright 1999-2001 (c) VA Linux Systems
--	http://sourceforge.net
--

COPY stats_site WITH OIDS TO '/home/tperdue/dumpfiles/stats_site.dump';
COPY stats_project WITH OIDS TO '/home/tperdue/dumpfiles/stats_project.dump';
COPY stats_project_developers WITH OIDS TO '/home/tperdue/dumpfiles/stats_project_developers.dump';
COPY stats_project_metric WITH OIDS TO '/home/tperdue/dumpfiles/stats_project_metric.dump';
COPY frs_dlstats_file_agg WITH OIDS TO '/home/tperdue/dumpfiles/frs_dlstats_file_agg.dump';
COPY stats_subd_pages WITH OIDS TO '/home/tperdue/dumpfiles/stats_subd_pages.dump';
COPY stats_agg_logo_by_group WITH OIDS TO '/home/tperdue/dumpfiles/stats_agg_logo_by_group.dump';
COPY stats_cvs_group WITH OIDS TO '/home/tperdue/dumpfiles/stats_cvs_group.dump';
COPY stats_agg_site_by_group WITH OIDS TO '/home/tperdue/dumpfiles/stats_agg_site_by_group.dump';
COPY stats_site_pages_by_day WITH OIDS TO '/home/tperdue/dumpfiles/stats_site_pages_by_day.dump';
COPY frs_package WITH OIDS TO '/home/tperdue/dumpfiles/frs_package.dump';
COPY frs_release WITH OIDS TO '/home/tperdue/dumpfiles/frs_release.dump';
COPY frs_processor WITH OIDS TO '/home/tperdue/dumpfiles/frs_processor.dump';
COPY frs_filetype WITH OIDS TO '/home/tperdue/dumpfiles/frs_filetype.dump';
COPY frs_file WITH OIDS TO '/home/tperdue/dumpfiles/frs_file.dump';
COPY project_weekly_metric WITH OIDS TO '/home/tperdue/dumpfiles/project_weekly_metric.dump';
COPY trove_cat WITH OIDS TO '/home/tperdue/dumpfiles/trove_cat.dump';
COPY trove_group_link WITH OIDS TO '/home/tperdue/dumpfiles/trove_group_link.dump';
COPY users WITH OIDS TO '/home/tperdue/dumpfiles/users.dump';
COPY groups WITH OIDS TO '/home/tperdue/dumpfiles/groups.dump';
COPY foundry_projects WITH oids to '/home/tperdue/dumpfiles/foundry_projects.dump';


DROP INDEX frs_release_date;
DROP INDEX frs_file_name;
DROP INDEX frs_file_processor;
DROP INDEX frs_file_type;
DROP INDEX frs_release_by;

CREATE UNIQUE INDEX statssite_oid ON stats_site(oid);
CREATE UNIQUE INDEX statsproject_oid ON stats_project(oid);
CREATE UNIQUE INDEX statsprojectdevelop_oid ON stats_project_developers(oid);
CREATE UNIQUE INDEX statsprojectmetric_oid ON stats_project_metric(oid);
CREATE UNIQUE INDEX frsdlfileagg_oid ON frs_dlstats_file_agg(oid);
CREATE UNIQUE INDEX statssubdpages_oid ON stats_subd_pages(oid);
CREATE UNIQUE INDEX statsagglogobygrp_oid ON stats_agg_site_by_group(oid);
CREATE UNIQUE INDEX statscvsgrp_oid ON stats_cvs_group(oid);
CREATE UNIQUE INDEX statsaggsitebygrp_oid ON stats_agg_site_by_group(oid);
CREATE UNIQUE INDEX statssitepgsbyday_oid ON stats_site_pages_by_day(oid);

DROP TABLE frs_dlstats_filetotal_agg;
DROP TABLE frs_dlstats_grouptotal_agg;
DROP TABLE frs_dlstats_group_agg;
DROP TABLE stats_project_months;
DROP TABLE stats_project_all;
DROP TABLE stats_project_last_30;
DROP TABLE stats_project_developers_last30;
DROP TABLE stats_site_pages_by_month;
DROP TABLE stats_site_last_30;
DROP TABLE stats_site_months;
DROP TABLE stats_site_all;
DROP TABLE trove_agg;
DROP TABLE trove_treesums;

DROP TABLE foundry_project_rankings_agg;
DROP TABLE foundry_project_downloads_agg;

