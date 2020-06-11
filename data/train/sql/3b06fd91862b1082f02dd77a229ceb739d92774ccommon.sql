-- =============================================================
-- =============================================================
-- =============================================================
-- TO REUSE IN ANOTHER BOUNDED CONTEXT, APPEND THIS FILE TO
-- THE END OF YOUR DDL
-- =============================================================
-- =============================================================
-- =============================================================
DROP TABLE IF EXISTS tbl_es_event_store;
CREATE TABLE `tbl_es_event_store` (
  `event_id`       BIGINT(20)     NOT NULL AUTO_INCREMENT,
  `event_body`     VARCHAR(20000) NOT NULL,
  `event_type`     VARCHAR(250)   NOT NULL,
  `stream_name`    VARCHAR(250)   NOT NULL,
  `stream_version` INT(11)        NOT NULL,
  KEY (`stream_name`),
  UNIQUE KEY (`stream_name`, `stream_version`),
  PRIMARY KEY (`event_id`)
)
  ENGINE = InnoDB;

DROP TABLE IF EXISTS tbl_published_notification_tracker;
CREATE TABLE `tbl_published_notification_tracker` (
  `published_notification_tracker_id`     BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `most_recent_published_notification_id` BIGINT(20)   NOT NULL,
  `type_name`                             VARCHAR(100) NOT NULL,
  `concurrency_version`                   INT(11)      NOT NULL,
  PRIMARY KEY (`published_notification_tracker_id`)
)
  ENGINE = InnoDB;

DROP TABLE IF EXISTS tbl_stored_event;
CREATE TABLE `tbl_stored_event` (
  `event_id`    BIGINT(20)     NOT NULL AUTO_INCREMENT,
  `event_body`  VARCHAR(20000) NOT NULL,
  `occurred_on` DATETIME       NOT NULL,
  `type_name`   VARCHAR(200)   NOT NULL,
  PRIMARY KEY (`event_id`)
)
  ENGINE = InnoDB;

DROP TABLE IF EXISTS tbl_time_constrained_process_tracker;
CREATE TABLE `tbl_time_constrained_process_tracker` (
  `time_constrained_process_tracker_id` BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `allowable_duration`                  BIGINT(20)   NOT NULL,
  `completed`                           TINYINT(1)   NOT NULL,
  `description`                         VARCHAR(100) NOT NULL,
  `process_id_id`                       VARCHAR(36)  NOT NULL,
  `process_informed_of_timeout`         TINYINT(1)   NOT NULL,
  `process_timed_out_event_type`        VARCHAR(200) NOT NULL,
  `retry_count`                         INT(11)      NOT NULL,
  `tenant_id`                           VARCHAR(36)  NOT NULL,
  `timeout_occurs_on`                   BIGINT(20)   NOT NULL,
  `total_retries_permitted`             BIGINT(20)   NOT NULL,
  `concurrency_version`                 INT(11)      NOT NULL,
  KEY `k_process_id` (`process_id_id`),
  KEY `k_tenant_id` (`tenant_id`),
  KEY `k_timeout_occurs_on` (`timeout_occurs_on`),
  PRIMARY KEY (`time_constrained_process_tracker_id`)
)
  ENGINE = InnoDB;
