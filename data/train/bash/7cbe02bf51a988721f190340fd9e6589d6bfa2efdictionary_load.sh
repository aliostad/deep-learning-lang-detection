

ls $1/* | while read line
do
                                           #Set -d/ , for other delimiters. Set for Pipe right now
echo "Drop TABLE auto_$(echo $line | cut -f 7 -d/ | cut -f 1 -d.) ;"  >> ./uhc/flat_file_drop.sql
echo "CREATE TABLE auto_$(echo $line | cut -f 7 -d/ | cut -f 1 -d.) ("  >> ./flat_file_ddl_and_load.sql
echo "$(head -q -n1 $line | sed -e 's/|/ varchar, \n/g; s/.$/ varchar); \n/g')" >> ./flat_file_ddl_and_load.sql
echo "" >> ./flat_file_ddl_and_load.sql

echo "\copy uhc_$(echo $line | cut -f 7 -d/ | cut -f 1 -d.) from $line delimiter '|' csv quote '~' header " >> ./flat_file_ddl_and_load.sql

echo "" >> ./flat_file_ddl_and_load.sql
echo "select * from  auto_$(echo $line | cut -f 7 -d/ | cut -f 1 -d.) limit 5 ;"  >> ./flat_file_ddl_and_load.sql
echo "" >> ./flat_file_ddl_and_load.sql
done




#sed -e 's/*date varchar,/*date date,/gI' <./flat_file_ddl_and_load.sql>./flat_file_ddl_and_load_sed.sql 


