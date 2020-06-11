#!/bin/bash

MYDIR=`dirname $0`
NUM_INSTANCES=4 #including coordinator
DB_NAME="mydb"
	
check_exit_status()
{
	if [ $1 -ne 0 ]; then 
		echo "Error above. Exiting. Peace."
		exit 1;
	fi
}

launch_db()
{
	pushd ../basic > /dev/null
	check_exit_status $?
	./runN.py $NUM_INSTANCES $DB_NAME init,start > /dev/null
	check_exit_status $?
	popd > /dev/null
}

build_data_gen()
{
	build data_gen
	pushd ../data_gen > /dev/null
	check_exit_status $?
	make > /dev/null
	check_exit_status $?
	popd > /dev/null
}

build_det_array()
{
	XMAX=$[ $HOR_CHUNKS * $CHUNK_WIDTH + $XMIN - 1 ]
	YMAX=$[ $VER_CHUNKS * $CHUNK_HEIGHT + $YMIN - 1 ]

	iquery -a -q "remove($ARR_NAME)" > /dev/null 2>&1
	iquery -a -q "remove(tmp)" > /dev/null 2>&1
	iquery -a -q "create array tmp <val:int64>[X=$XMIN:$XMAX,$CHUNK_WIDTH,0, Y=$YMIN:$YMAX,$CHUNK_HEIGHT,0]" > /dev/null
	check_exit_status $?
	iquery -a -n -q "store(build(tmp, Y-$YMIN + (X-($XMIN)) * ($YMAX-$YMIN+1)), $ARR_NAME)" > /dev/null
	check_exit_status $?
	iquery -a -q "remove(tmp)" > /dev/null 2>&1
	check_exit_status $?
}

build_fat_array()
{
	XMAX=$[ $HOR_CHUNKS * $CHUNK_WIDTH + $XMIN - 1 ]
	YMAX=$[ $VER_CHUNKS * $CHUNK_HEIGHT + $YMIN - 1 ]

	iquery -a -q "remove($ARR_NAME)" > /dev/null 2>&1
	iquery -a -q "remove(tmp)" > /dev/null 2>&1
	iquery -a -q "create array tmp <val:int64>[X=$XMIN:$XMAX,$CHUNK_WIDTH,0, Y=$YMIN:$YMAX,$CHUNK_HEIGHT,0]" > /dev/null
	check_exit_status $?
	iquery -a -n -q "store(join( join( build(tmp, Y-$YMIN + (X-($XMIN)) * ($YMAX-$YMIN+1)), build(tmp, Y-$YMIN + (X-($XMIN)) * ($YMAX-$YMIN+1))), build(tmp, Y-$YMIN + (X-($XMIN)) * ($YMAX-$YMIN+1)) ), $ARR_NAME)" > /dev/null
	check_exit_status $?
	iquery -a -q "remove(tmp)" > /dev/null 2>&1
	check_exit_status $?
}

build_xy_array()
{
	XMAX=$[ $HOR_CHUNKS * $CHUNK_WIDTH + $XMIN - 1 ]
	YMAX=$[ $VER_CHUNKS * $CHUNK_HEIGHT + $YMIN - 1 ]

	iquery -a -q "remove($ARR_NAME)" > /dev/null 2>&1
	iquery -a -q "remove(tmp)" > /dev/null 2>&1
	iquery -a -q "create array tmp <val:int64>[X=$XMIN:$XMAX,$CHUNK_WIDTH,0, Y=$YMIN:$YMAX,$CHUNK_HEIGHT,0]" > /dev/null
	check_exit_status $?
	iquery -a -n -q "store ( join (build(tmp, X-$XMIN), build(tmp, Y-$YMIN)), $ARR_NAME)" > /dev/null
	check_exit_status $?
	iquery -a -q "remove(tmp)" > /dev/null 2>&1
	check_exit_status $?
}

build_1d()
{
	XMAX=$[ $HOR_CHUNKS * $CHUNK_WIDTH + $XMIN - 1 ]
	
	iquery -a -q "remove($ARR_NAME)" > /dev/null 2>&1
	iquery -a -q "remove(tmp)" > /dev/null 2>&1
	iquery -a -q "create array tmp <val:int64>[X=$XMIN:$XMAX,$CHUNK_WIDTH,0]" > /dev/null
	check_exit_status $?
	iquery -a -n -q "store(build(tmp, (X-($XMIN))), $ARR_NAME)" > /dev/null
	check_exit_status $?
	iquery -a -q "remove(tmp)" > /dev/null 2>&1
	check_exit_status $?
}

build_1d_reverse()
{
	XMAX=$[ $HOR_CHUNKS * $CHUNK_WIDTH + $XMIN - 1 ]
	
	iquery -a -q "remove($ARR_NAME)" > /dev/null 2>&1
	iquery -a -q "remove(tmp)" > /dev/null 2>&1
	iquery -a -q "create array tmp <val:int64>[X=$XMIN:$XMAX,$CHUNK_WIDTH,0]" > /dev/null
	check_exit_status $?
	iquery -a -n -q "store(build(tmp, $XMAX - X), $ARR_NAME)" > /dev/null
	check_exit_status $?
	iquery -a -q "remove(tmp)" > /dev/null 2>&1
	check_exit_status $?
}



pushd $MYDIR > /dev/null

#make sure db is up
iquery -a -q "list()" > /dev/null
if [ $? -ne 0 ]; then
	echo "Can't access db... trying to restart"
	killall scidb > /dev/null 2>&1
	launch_db
fi

#create dense, distributed array of ints
#dimensions: 1:2000 x 1:2000 
#chunk size: 1000x1000
#distro 
# [1,1->1000,1000] [1001,1 -> 2000,1000]
# [1,1001->1000,2000] [10001,10001->20000,2000]


#DATAFILE="/tmp/$ARR_NAME.data"
#../data_gen/gen_matrix -d $HOR_CHUNKS $VER_CHUNKS $CHUNK_WIDTH $CHUNK_HEIGHT 1.0 N > $DATAFILE 
#check_exit_status $?
#iquery -a -q "load($ARR_NAME, '$DATAFILE')"

ARR_NAME="opt_dense_quad"
HOR_CHUNKS=2
VER_CHUNKS=2
CHUNK_WIDTH=2000
CHUNK_HEIGHT=2000
XMIN=0
YMIN=0
build_det_array

ARR_NAME="tbt"
HOR_CHUNKS=2
VER_CHUNKS=2
CHUNK_WIDTH=1
CHUNK_HEIGHT=1
XMIN=0
YMIN=0
build_det_array

ARR_NAME="tbt2"
HOR_CHUNKS=2
VER_CHUNKS=2
CHUNK_WIDTH=1
CHUNK_HEIGHT=1
XMIN=0
YMIN=0
build_det_array

ARR_NAME="fbf"
HOR_CHUNKS=2
VER_CHUNKS=2
CHUNK_WIDTH=2
CHUNK_HEIGHT=2
XMIN=0
YMIN=0
build_det_array

ARR_NAME="single_dim"
HOR_CHUNKS=4
VER_CHUNKS=1
CHUNK_WIDTH=1
CHUNK_HEIGHT=1
XMIN=1
YMIN=1
build_1d

ARR_NAME="single_dim_reverse"
HOR_CHUNKS=4
VER_CHUNKS=1
CHUNK_WIDTH=1
CHUNK_HEIGHT=1
XMIN=1
YMIN=1
build_1d_reverse

ARR_NAME="opt_dense_quad_small_1"
HOR_CHUNKS=400
VER_CHUNKS=400
CHUNK_WIDTH=1
CHUNK_HEIGHT=1
XMIN=0
YMIN=0
#build_det_array

ARR_NAME="opt_dense_quad_small_2"
HOR_CHUNKS=400
VER_CHUNKS=400
CHUNK_WIDTH=1
CHUNK_HEIGHT=1
XMIN=0
YMIN=0
#build_det_array

ARR_NAME="one_by_four"
HOR_CHUNKS=4
VER_CHUNKS=1
CHUNK_WIDTH=1
CHUNK_HEIGHT=1
XMIN=0
YMIN=0
build_det_array

ARR_NAME="four_by_one"
HOR_CHUNKS=1
VER_CHUNKS=4
CHUNK_WIDTH=1
CHUNK_HEIGHT=1
XMIN=0
YMIN=0
build_det_array

ARR_NAME="four_by_four"
HOR_CHUNKS=4
VER_CHUNKS=4
CHUNK_WIDTH=1
CHUNK_HEIGHT=1
XMIN=0
YMIN=0
build_det_array

ARR_NAME="four_by_four2"
HOR_CHUNKS=4
VER_CHUNKS=4
CHUNK_WIDTH=1
CHUNK_HEIGHT=1
XMIN=0
YMIN=0
build_det_array

ARR_NAME="opt_dense_quad_small_100"
HOR_CHUNKS=40
VER_CHUNKS=40
CHUNK_WIDTH=100
CHUNK_HEIGHT=100
XMIN=0
YMIN=0
build_det_array

ARR_NAME="opt_dense_quad_small_fat"
HOR_CHUNKS=400   
VER_CHUNKS=400
CHUNK_WIDTH=1
CHUNK_HEIGHT=1
XMIN=0
YMIN=0
#build_fat_array

ARR_NAME="opt_dense_quad_fat"
HOR_CHUNKS=40
VER_CHUNKS=40
CHUNK_WIDTH=100
CHUNK_HEIGHT=100
XMIN=0
YMIN=0
build_fat_array

#ARR_NAME="opt_sparse_quad_small"	
#iquery -a -q "remove($ARR_NAME)" > /dev/null 2>&1
#iquery -anq "store(build_sparse(opt_dense_quad_small_1, X+Y, X>=197 and X<=205 and Y>=198 and Y<=210), $ARR_NAME)" > /dev/null 2>&1
#check_exit_status $?

#ARR_NAME="opt_sparse_quad_small_2"	
#iquery -a -q "remove($ARR_NAME)" > /dev/null 2>&1
#iquery -anq "store(build_sparse(opt_dense_quad_small_1, X+Y, X>=194 and X<=203 and Y>=199 and Y<=211), $ARR_NAME)" > /dev/null 2>&1
#check_exit_status $?

