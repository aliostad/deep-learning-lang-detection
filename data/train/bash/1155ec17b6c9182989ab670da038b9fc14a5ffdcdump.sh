read -p "What's the mysql host name to export data from : "  hostname

read -p "What username : " username

printf "password\n"

read -s password

read -p "What database contains the table you would like to dump : " database

read -p "What table contains the rows you would like to chunk : " table

count=$(mysql -u $username -p$password -h $hostname -e "SELECT COUNT(*) FROM $database.$table" | awk 'NR==2')

echo "Currently this table has a total of $count rows"
read -p "How many rows per file would you like to have : " rowsPerFile

numFiles=$(python -c "import math; print math.ceil($count/float($rowsPerFile))")

echo "This will result in $numFiles files"

read -p "Where would you like to put these files : " filePath

i=0
chunk=1
while [[ $i -le $count ]]
do

    n=$(($i + $rowsPerFile))
    dumpfile=$filePath"/"$database"_chunk_"$chunk".sql"

    printf "Creating $dumpfile \n"

    if [[ $chunk -eq 1 ]]
        then
            mysqldump -u $username -p$password -h $hostname --where "1 LIMIT $i, $rowsPerFile" $database $table > $dumpfile
        else
            mysqldump -u $username -p$password -h $hostname --skip-add-locks --no-create-info --where "1 LIMIT $i, $rowsPerFile" $database $table > $dumpfile
    fi

    i=$n
    chunk=$(($chunk + 1))
done