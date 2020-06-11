-- Create Scheduler class

SELECT system_class_create('Scheduler', 'Class', false, 'MODE: reserved|TYPE: class|DESCR: Scheduler|SUPERCLASS: false|STATUS: active');

COMMENT ON COLUMN "Scheduler"."Code" IS 'MODE: read|DESCR: Job Type|INDEX: 1';
COMMENT ON COLUMN "Scheduler"."Description" IS 'MODE: read|DESCR: Job Description|INDEX: 2';
COMMENT ON COLUMN "Scheduler"."Notes" IS 'MODE: read|DESCR: Job Parameters|INDEX: 3';

SELECT system_attribute_create('Scheduler', 'CronExpression', 'text', '', true, false,
	'MODE: read|DESCR: Cron Expression|INDEX: 8|STATUS: active', '', '', '', null);

SELECT system_attribute_create('Scheduler', 'Detail', 'text', '', true, false,
	'MODE: read|DESCR: Job Detail|INDEX: 8|STATUS: active', '', '', '', null);
