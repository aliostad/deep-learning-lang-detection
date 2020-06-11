USE pdqBLAST;

CALL job_add("blastn", 1, "blastn arguments", "blast db", "input query", 2, "output_table_job1", @new_job_id);
CALL job_update_temporary_directory(@new_job_id, "temporary directory");
SELECT "";
SELECT CONCAT("created new job with job_id = ", @new_job_id);
CALL job_status_waiting(@new_job_id);
CALL job_status(@new_job_id);
SELECT "";
CALL job_work_unit_load_script(@new_job_id, 1, "/gscratch/escience/dacb/pdqBLAST/example.pdqBLASTrc");
CALL job_work_unit_status_submitted(@new_job_id, 1, "fake scheduler id");
CALL job_work_unit_status_staging(@new_job_id, 1, "node name", "local temporary directory");
CALL job_work_unit_load_stage_log(@new_job_id, 1, "/gscratch/escience/dacb/pdqBLAST/example.pdqBLASTrc");
CALL job_work_unit_status_running(@new_job_id, 1);
CALL job_work_unit_load_blast_log(@new_job_id, 1, "/gscratch/escience/dacb/pdqBLAST/example.pdqBLASTrc");
CALL job_work_unit_status_loading(@new_job_id, 1);
CALL job_work_unit_status_cleanup(@new_job_id, 1);
CALL job_work_unit_load_cleanup_log(@new_job_id, 1, "/gscratch/escience/dacb/pdqBLAST/example.pdqBLASTrc");
CALL job_work_unit_status_complete(@new_job_id, 1);
CALL job_work_unit_status(@new_job_id);
CALL job_work_unit_status_submitted(@new_job_id, 2, "fake scheduler id");
CALL job_work_unit_status_staging(@new_job_id, 2, "node name", "local temporary directory");
CALL job_work_unit_status_running(@new_job_id, 2);
CALL job_work_unit_status_loading(@new_job_id, 2);
CALL job_work_unit_status_cleanup(@new_job_id, 2);
CALL job_work_unit_status_complete(@new_job_id, 2);
CALL job_work_unit_status(@new_job_id);
SELECT "";
CALL job_status(@new_job_id);
SELECT "";
SELECT "";

CALL job_add("blastn", 1, "blastn arguments", "blast db", "input query", 8, "output_table_job2", @new_job_id);
CALL job_update_temporary_directory(@new_job_id, "temporary directory");
SELECT CONCAT("created new job with job_id = ", @new_job_id);
SELECT "";
CALL job_status(@new_job_id);
SELECT "";
CALL job_work_unit_status(@new_job_id);
SELECT "";

CALL job_status(1);
SELECT "";

CALL job_work_unit_node(2, 1, @node);
SELECT "node for job 2 work unit 1: ", @node;
CALL job_work_unit_temporary_directory(2, 1, @temporary_directory);
SELECT "temporary directory for job 2 work unit 1: ", @temporary_directory;
