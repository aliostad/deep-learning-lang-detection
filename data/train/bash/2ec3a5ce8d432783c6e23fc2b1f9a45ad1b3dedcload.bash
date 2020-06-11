#! /bin/bash
set -e

if [ $# -ne 1 -o -z "$1" ]
then
    echo "Please supply a table name"
    exit 1
fi
TABLE=$1

SQL_DIR=/sps/lsst/Qserv/smm/db_tests_summer15/sql
DATA_DIR=/qserv/data_generation
CHUNKS_DIR=$DATA_DIR/chunks

source /qserv/stack/loadLSST.bash
setup mysql

# Obtain the list of chunks owned by this node.
CHUNKS=`/sps/lsst/Qserv/smm/db_tests_summer15/scripts/my_chunks.py`

MYSQL="mysql -u qsmaster -S /qserv/run/var/lib/mysql/mysql.sock -A -D LSST"

# Create a template for the table we want to create.
$MYSQL < $SQL_DIR/$TABLE.sql

# Create the special chunk for the table
$MYSQL -e "CREATE TABLE ${TABLE}_1234567890 LIKE $TABLE"

# Remove the local portion of the deepSourceId to partition
# mapping if we are loading Objects (we are about to recompute it).
if [ $TABLE == Object ]
then
    rm -f $DATA_DIR/object-locations.tsv
fi

for C in $CHUNKS ; do
    echo "`date`: loading chunk $C ..."

    CHUNK_FILE=$CHUNKS_DIR/$TABLE/chunk_$C.txt
    CHUNK_TABLE=${TABLE}_${C}

    # Create the chunk table.
    $MYSQL -e "CREATE TABLE $CHUNK_TABLE LIKE $TABLE"

    if [ -s $CHUNK_FILE ]
    then
        # Load the chunk table with the usual optimizations.
        $MYSQL <<STATEMENTS
            SET myisam_sort_buffer_size = 4294967296;
            ALTER TABLE $CHUNK_TABLE DISABLE KEYS;
            LOAD DATA INFILE '$CHUNK_FILE' INTO TABLE $CHUNK_TABLE;
            SHOW WARNINGS;
            ALTER TABLE $CHUNK_TABLE ENABLE KEYS;
STATEMENTS
            if [ $TABLE == Object ]
            then
                # If this is the Object table, extract the local portion of the
                # deepSourceId to partition mapping.
                $MYSQL -B --quick --disable-column-names \
                       -e "SELECT deepSourceId, chunkId, subChunkId FROM $CHUNK_TABLE" \
                    >> $DATA_DIR/object-locations.tsv
            fi
    fi

    if [ $TABLE == Object ]
    then
        # For the Object table, additionally create and load overlap chunks.
        CHUNK_FILE=$CHUNKS_DIR/$TABLE/chunk_${C}_overlap.txt
        CHUNK_TABLE=${TABLE}FullOverlap_${C}

        # Drop the PK, because a single Object can be in the overlap region
        # of more than one chunk.
        $MYSQL <<STATEMENTS
            CREATE TABLE $CHUNK_TABLE LIKE $TABLE;
            ALTER TABLE $CHUNK_TABLE DROP PRIMARY KEY;
            ALTER TABLE $CHUNK_TABLE ADD KEY (deepSourceId);
STATEMENTS
        if [ -s $CHUNK_FILE ]
        then
            $MYSQL <<STATEMENTS
                SET myisam_sort_buffer_size = 4294967296;
                ALTER TABLE $CHUNK_TABLE DISABLE KEYS;
                LOAD DATA INFILE '$CHUNK_FILE' INTO TABLE $CHUNK_TABLE;
                SHOW WARNINGS;
                ALTER TABLE $CHUNK_TABLE ENABLE KEYS;
STATEMENTS
        fi
    fi

done

echo "`date`: checksumming"

sha512sum $DATA_DIR/object-locations.tsv \
        > $DATA_DIR/object-locations.tsv.sha512

sha512sum /qserv/run/var/lib/mysql/LSST/$TABLE* \
        > $CHUNKS_DIR/$TABLE.sha512

echo "`date`: done!"
