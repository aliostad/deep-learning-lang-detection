
-- low-high-cast2.sql
-- Jared Still
-- http://www.pythian.com/blog/author/still/
-- still@pythian.com
-- jkstill@gmail.com

col low_value format a20
col high_value format a20
col table_name format a10 head 'TABLE'
col data_type format a20
col column_name format a6 head 'COLUMN'

set linesize 200 trimspool on
set pagesize 60

select
	us.table_name,
	uc.data_type,
	us.column_name,
	case 
		when uc.data_type in ('VARCHAR2','VARCHAR','CHAR')  then
			utl_raw.cast_to_varchar2(us.low_value)
		when uc.data_type = 'NUMBER' then
			to_char(utl_raw.cast_to_number(us.low_value) )
		when uc.data_type = 'DATE' then
	 		-- extract the century and year information from the
	 		-- internal date format
	 		-- century = (century byte -100) * 100
			to_char((
		  		to_number(
			   		-- parse out integer appearing before first comma
			   		substr( substr(dump(us.low_value),15), 1, instr(substr(dump(us.low_value),15),',')-1) - 100
		  		) * 100
	 		)
	 		+
	 		-- year = year byte - 100
	 		(
		  		to_number(
			   		substr(
				    		substr(dump(us.low_value),15),
				    		-- get position of 2nd comma
				    		instr(substr(dump(us.low_value),15),',',2)+1,
				    		-- get position of 2nd comma - position of 1st comma
				    		instr(substr(dump(us.low_value),15),',',1,2) - instr(substr(dump(us.low_value),15),',',1,1) -1
			   		)
		  		)
		  		- 100
	 		)) --current_year
			   		|| '-' ||
						lpad(
							substr(
				    			substr(dump(us.low_value),15),
				    			instr(substr(dump(us.low_value),15),',',1,2)+1,
				    			instr(substr(dump(us.low_value),15),',',1,3) - instr(substr(dump(us.low_value),15),',',1,2) -1
			   			) -- month
							,2,'0'
						)
			   		||  '-' ||
						lpad(
							substr(
				    			substr(dump(us.low_value),15),
				    			instr(substr(dump(us.low_value),15),',',1,3)+1,
				    			instr(substr(dump(us.low_value),15),',',1,4) - instr(substr(dump(us.low_value),15),',',1,3) -1
			   			) -- day
							,2,'0'
						)
			   		|| ' ' ||
			   		lpad(
				    		to_char(to_number(
					     		substr(
						      		substr(dump(us.low_value),15),
						      		instr(substr(dump(us.low_value),15),',',1,4)+1,
						      		instr(substr(dump(us.low_value),15),',',1,5) - instr(substr(dump(us.low_value),15),',',1,4) -1
					     		)
				    		)-1)
				    		,2,'0'
			   		) -- hour
			   		|| ':' ||
			   		lpad(
				    		to_char(
					     		to_number(
						      		substr(
										substr(dump(us.low_value),15),
										instr(substr(dump(us.low_value),15),',',1,5)+1,
										instr(substr(dump(us.low_value),15),',',1,6) - instr(substr(dump(us.low_value),15),',',1,5) -1
						      		)
					     		)-1
				    		)
				    		,2,'0'
			   		) -- minute
			   		|| ':' ||
			   		lpad(
				    		to_char(
					     		to_number(
						      		substr(
										substr(dump(us.low_value),15),
										instr(substr(dump(us.low_value),15),',',1,6)+1
						      		)
					     		)-1
				    		)
				    		,2,'0'
			   		) --second
			else 'NOT SUPPORTED'
			end low_value,
			-- get the high value
	case
		when uc.data_type in ('VARCHAR2','VARCHAR','CHAR')  then
			utl_raw.cast_to_varchar2(us.high_value)
		when uc.data_type = 'NUMBER' then
			to_char(utl_raw.cast_to_number(us.high_value) )
		when uc.data_type = 'DATE' then
	 		-- extract the century and year information from the
	 		-- internal date format
	 		-- century = (century byte -100) * 100
			to_char((
		  		to_number(
			   		-- parse out integer appearing before first comma
			   		substr( substr(dump(us.high_value),15), 1, instr(substr(dump(us.high_value),15),',')-1) - 100
		  		) * 100
	 		)
	 		+
	 		-- year = year byte - 100
	 		(
		  		to_number(
			   		substr(
				    		substr(dump(us.high_value),15),
				    		-- get position of 2nd comma
				    		instr(substr(dump(us.high_value),15),',',2)+1,
				    		-- get position of 2nd comma - position of 1st comma
				    		instr(substr(dump(us.high_value),15),',',1,2) - instr(substr(dump(us.high_value),15),',',1,1) -1
			   		)
		  		)
		  		- 100
	 		)) --current_year
			   		|| '-' ||
						lpad(
							substr(
				    			substr(dump(us.high_value),15),
				    			instr(substr(dump(us.high_value),15),',',1,2)+1,
				    			instr(substr(dump(us.high_value),15),',',1,3) - instr(substr(dump(us.high_value),15),',',1,2) -1
			   			) -- month
							,2,'0'
						)
			   		||  '-' ||
						lpad(
							substr(
				    			substr(dump(us.high_value),15),
				    			instr(substr(dump(us.high_value),15),',',1,3)+1,
				    			instr(substr(dump(us.high_value),15),',',1,4) - instr(substr(dump(us.high_value),15),',',1,3) -1
			   			) -- day
							,2,'0'
						)
			   		|| ' ' ||
			   		lpad(
				    		to_char(to_number(
					     		substr(
						      		substr(dump(us.high_value),15),
						      		instr(substr(dump(us.high_value),15),',',1,4)+1,
						      		instr(substr(dump(us.high_value),15),',',1,5) - instr(substr(dump(us.high_value),15),',',1,4) -1
					     		)
				    		)-1)
				    		,2,'0'
			   		) -- hour
			   		|| ':' ||
			   		lpad(
				    		to_char(
					     		to_number(
						      		substr(
										substr(dump(us.high_value),15),
										instr(substr(dump(us.high_value),15),',',1,5)+1,
										instr(substr(dump(us.high_value),15),',',1,6) - instr(substr(dump(us.high_value),15),',',1,5) -1
						      		)
					     		)-1
				    		)
				    		,2,'0'
			   		) -- minute
			   		|| ':' ||
			   		lpad(
				    		to_char(
					     		to_number(
						      		substr(
										substr(dump(us.high_value),15),
										instr(substr(dump(us.high_value),15),',',1,6)+1
						      		)
					     		)-1
				    		)
				    		,2,'0'
			   		) --second
			else 'NOT SUPPORTED'
			end high_value
from all_tab_col_statistics us
join all_tab_columns uc on uc.owner = us.owner
	and uc.table_name = us.table_name
	and uc.column_name = us.column_name
	and us.owner = USER
	and us.table_name = 'LOW_HIGH'
	--and us.column_name in ('C1','N1')
order by uc.column_id
/


