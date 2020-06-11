SQL_CMD="mysql-dbrc digenei3"

echo "Load nr-journal-mesh-p"
cd DATA; echo "LOAD DATA LOCAL INFILE 'nr-journal-mesh-p.txt' INTO TABLE nr_journal_mesh_p FIELDS TERMINATED BY '|'" | $SQL_CMD ; cd ..

echo "Load journal-min2005-mesh-p"
cd DATA; echo "LOAD DATA LOCAL INFILE 'journal-min2005-mesh-p.txt' INTO TABLE journal_min2005_mesh_p FIELDS TERMINATED BY '|'" | $SQL_CMD ; cd ..

echo "Load nr-min2005-journal-mesh-p"
cd DATA; echo "LOAD DATA LOCAL INFILE 'nr-journal-min2005-mesh-p.txt' INTO TABLE nr_journal_min2005_mesh_p FIELDS TERMINATED BY '|'" | $SQL_CMD ; cd ..
