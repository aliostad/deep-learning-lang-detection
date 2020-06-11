#!/bin/bash
# Uma vez na vida execute o comando abaixo
# sudo chmod u+rwx $VIRTUOSO_HOME/var/lib/virtuoso/db/dumps/ 

if [ -z "$VIRTUOSO_HOME" ]; then
    echo "Need to set \$VIRTUOSO_HOME "
    exit 1
fi

function cp_ttl {
  cp $1$2 $VIRTUOSO_DUMP_DIR
  chmod a+rwx $VIRTUOSO_HOME/dumps/$2
}

function map {
   # Executa mapeamento e migração de dados
        pushd .
        cd ../mapping
        echo "Mapping $1"
        time ./run_r2r $1 STAG
	    popd
}

function load {
    cp_ttl ../data/ data_$1.ttl 
    echo "DB.DBA.TTLP_MT_LOCAL_FILE('dumps/data_$1.ttl','', 'http://semantica.globo.com/$1/');" > load_$1.tsh
    echo "rdfs_rule_set('http://semantica.globo.com/ruleset', 'http://semantica.globo.com/$1/');" >> load_$1.tsh
    chmod a+rwx load_$1.tsh
    time ./run_isql.sh load_$1.tsh
    #rm load_$1.tsh
}

VIRTUOSO_DUMP_DIR=$VIRTUOSO_HOME/dumps
for filename in `ls ../schema`
do 
  cp_ttl ../schema/ $filename
done

# Faz mapeamento
map place 
map organization
map person
 
# Faz carga de dados
load place
load organization
load person
