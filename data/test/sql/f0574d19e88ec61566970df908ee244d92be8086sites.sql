CREATE TABLE sites (
    id                                  SERIAL PRIMARY KEY,
    key                                 VARCHAR(64),
    name                                VARCHAR(256),

    proxy_prefix                        VARCHAR(512),
    proxy_WAM                           VARCHAR(512),
    proxy_prefix_alternate              VARCHAR(512),
    email                               VARCHAR(1024),
    erm_notification_email              VARCHAR(1024),

    cjdb_results_per_page               VARCHAR(1024),
    cjdb_unified_journal_list           VARCHAR(1024),
    cjdb_show_citations                 VARCHAR(1024),
    cjdb_hide_citation_coverage         VARCHAR(1024),
    cjdb_display_db_name_only           VARCHAR(1024),
    cjdb_print_name                     VARCHAR(1024),
    cjdb_print_link_label               VARCHAR(1024),

    cjdb_authentication_module          VARCHAR(1024),
    cjdb_authentication_server          VARCHAR(1024),
    cjdb_authentication_string1         VARCHAR(1024),
    cjdb_authentication_string2         VARCHAR(1024),
    cjdb_authentication_string3         VARCHAR(1024),
    cjdb_authentication_level100        VARCHAR(1024),
    cjdb_authentication_level50         VARCHAR(1024),

    marc_dump_856_link_label            VARCHAR(1024),
    marc_dump_duplicate_title_field     VARCHAR(1024),
    marc_dump_cjdb_id_field             VARCHAR(1024),
    marc_dump_cjdb_id_indicator1        VARCHAR(1024),
    marc_dump_cjdb_id_indicator2        VARCHAR(1024),
    marc_dump_cjdb_id_subfield          VARCHAR(1024),
    marc_dump_holdings_field            VARCHAR(1024),
    marc_dump_holdings_indicator1       VARCHAR(1024),
    marc_dump_holdings_indicator2       VARCHAR(1024),
    marc_dump_holdings_subfield         VARCHAR(1024),
    marc_dump_medium_text               VARCHAR(1024),
    marc_dump_direct_links              BOOLEAN DEFAULT false,
    
    rebuild_cjdb                        VARCHAR(1024),
    rebuild_MARC                        VARCHAR(1024),
    rebuild_ejournals_only              VARCHAR(1024),
    show_ERM                            VARCHAR(1024),
    test_MARC_file                      VARCHAR(1024),
    
    google_scholar_on                   VARCHAR(1024),
    google_scholar_keywords             VARCHAR(1024),
    google_scholar_e_link_label         VARCHAR(1024),
    google_scholar_other_link_label     VARCHAR(1024),
    google_scholar_openurl_base         VARCHAR(1024),
    google_scholar_other_xml            VARCHAR(1024),

    active                  BOOLEAN DEFAULT TRUE,

    created                 TIMESTAMP NOT NULL DEFAULT NOW(),
    modified                TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX sites_key_idx on sites(key);

