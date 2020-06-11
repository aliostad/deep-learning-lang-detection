/*
SQL AGENT JOB :  DAILY
=======================================================================
*/

GENERAL
----------------------------------------------------
NAME:		Daily
OWNER:	gemuser
CATEGORY:	GEM
DESCRIPTION:	NONE



STEPS
----------------------------------------------------
STEP NAME:		Daily processing
TYPE:			Transact-SQL script (T-SQL)
RUN AS:
DATABASE:		GEMdb

COMMAND:		exec sp_Recur_ProcessItems 'support'

ADVANCED:
ON SUCCESS:	Go to the next step
ON FAILURE:		Go to the next step
OUTPUT FILE:		<PATH TO SQLJobs.log FILE >
Append		CHECKED

Run as user:		gemuser

---------------------------------------------------------------------------------------------------------

STEP NAME:		Post Recur Batch
TYPE:			Transact-SQL script (T-SQL)
RUN AS:
DATABASE:		GEMdb

COMMAND:		declare @d datetime
			set @d = getdate()
			exec sp_Batch_Post 'system','recur',@d

ADVANCED:
ON SUCCESS:	Quit Job Reporting Success
ON FAILURE:		Quit Job Reporting Failure
OUTPUT FILE:		<PATH TO SQLJobs.log FILE >
Append		CHECKED

Run as user:		gemuser




SCHEDULES
----------------------------------------------------
Schedule Name:	Daily
Schedule Time:	11:00:00 PM