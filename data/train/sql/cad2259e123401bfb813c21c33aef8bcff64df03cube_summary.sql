-- Summarizes all levels of a group of variables (creates a cube)
-- Uses PLPython as a string manipulator but executes pure SQL
-- Takes in the following arguments...
--     input_table: schema.tablename for table to summarize
--     cube_table: schema.tablename for output table
--     by_columns: comma-separated list of columns to summarize by
--                 note that these columns will be converted to text so they can be unioned together with nulls
--     cube_function: SQL aggregation function which can be used as a group by (in SQL syntax) e.g.
--                    "avg(sales) as avg_sales"
--                    "count(distinct user) as users, sum(sales) as total_sales"
create or replace function cube_summary(input_table text, cube_table text, by_columns text, cube_function text) 
returns text as
$$

import itertools

# Separate out list of by columns
by_list = [b.strip() for b in by_columns.split(',')]

# Use itertools to get all combinations of by columns
comb_list = []
for i in range(len(by_list)):
    comb_list.append(itertools.combinations(by_list, i + 1))

# Loop through combinations calculate summary and union results together
execute_str = 'create table ' + cube_table + ' as select '
for comb in comb_list:
    for c in comb:
        group_by_list = []
        for b in by_list:
            if b in c:
                group_by_list.append(b)
                execute_str = execute_str + 'cast(' + b + ' as text) as ' + b + ', '
            else:
                execute_str = execute_str + 'null as ' + b + ', '
        execute_str = execute_str + cube_function + ' from ' + input_table + ' group by '
        for b in group_by_list[:-1]:
            execute_str = execute_str + b + ', '
        execute_str = execute_str + group_by_list[-1] + ' union all select '

# Summary without any by variables
for b in by_list:
    execute_str = execute_str + 'null as ' + b + ', '
execute_str = execute_str + cube_function + ' from ' + input_table + ';'

# Execute SQL and return the SQL string
plpy.execute(execute_str)
return execute_str

$$
language plpythonu;
