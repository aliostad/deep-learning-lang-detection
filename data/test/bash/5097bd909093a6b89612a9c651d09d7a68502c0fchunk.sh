
grep "chunk = 8192"  $1 | grep "OPTIQ_" > $2/8k.dat
grep "chunk = 16384" $1 | grep "OPTIQ_" > $2/16k.dat
grep "chunk = 32768" $1 | grep "OPTIQ_" > $2/32k.dat
grep "chunk = 65536" $1 | grep "OPTIQ_" > $2/64k.dat
grep "chunk = 131072" $1 | grep "OPTIQ_" > $2/128k.dat
grep "chunk = 262144" $1 | grep "OPTIQ_" > $2/256k.dat
grep "chunk = 524288" $1 | grep "OPTIQ_" > $2/512k.dat
grep "chunk = 1048576" $1 | grep "OPTIQ_" > $2/1m.dat
grep "chunk = 2097152" $1 | grep "OPTIQ_" > $2/2m.dat
grep "chunk = 4194304" $1 | grep "OPTIQ_" > $2/4m.dat
grep "chunk = 8388608" $1 | grep "OPTIQ_" > $2/8m.dat
