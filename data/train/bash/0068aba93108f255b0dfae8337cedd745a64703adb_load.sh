# set -vx
cd $HOME/gsn

sudo chown -R pdipietro:pdipietro ./neo4j/data/graph.db ./log/db_load.log ./log/db_load_stderr.log
rm -r ./log/db_load.log ./log/db_load_stderr.log ./neo4j/data/graph.db   2>./log/db_load_stderr.log

sudo cat $HOME/gsn-data/load_domain_data/metamodel.cypher.txt | ./neo4j/bin/neo4j-shell neo4j.properties -path ./neo4j/data/graph.db > ./log/db_load.log   2>>./log/db_load_stderr.log
sudo cat $HOME/gsn-data/load_domain_data/countries.cypher.txt | ./neo4j/bin/neo4j-shell neo4j.properties -path ./neo4j/data/graph.db >> ./log/db_load.log   2>>./log/db_load_stderr.log
sudo cat $HOME/gsn-data/load_domain_data/sex.cypher.txt | ./neo4j/bin/neo4j-shell neo4j.properties -path ./neo4j/data/graph.db >> ./log/db_load.log	  2>>./log/db_load_stderr.log
sudo cat $HOME/gsn-data/load_domain_data/languages.cypher.txt | ./neo4j/bin/neo4j-shell neo4j.properties -path ./neo4j/data/graph.db >> ./log/db_load.log	  2>>./log/db_load_stderr.log

