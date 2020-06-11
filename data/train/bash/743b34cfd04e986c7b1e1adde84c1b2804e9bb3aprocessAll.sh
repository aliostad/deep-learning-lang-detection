

#$1: file size
#$2: num gens
#$3: cpu
#$4: coding rate
#$5: precoding
#$6: set1, 2, or 3


#set1
#no cpu set
./process.sh 1 1 0 100 0 1
./process.sh 1 5 0 100 0 1
./process.sh 1 10 0 100 0 1
./process.sh 1 50 0 100 0 1

./process.sh 5 1 0 100 0 1
./process.sh 5 5 0 100 0 1
./process.sh 5 10 0 100 0 1
./process.sh 5 50 0 100 0 1
./process.sh 5 250 0 100 0 1

./process.sh 10 1 0 100 0 1
./process.sh 10 5 0 100 0 1
./process.sh 10 10 0 100 0 1
./process.sh 10 50 0 100 0 1
./process.sh 10 500 0 100 0 1

#cpu set
./process.sh 1 1 1 100 0 1
./process.sh 1 5 1 100 0 1
./process.sh 1 10 1 100 0 1
./process.sh 1 50 1 100 0 1

./process.sh 5 1 1 100 0 1
./process.sh 5 5 1 100 0 1
./process.sh 5 10 1 100 0 1
./process.sh 5 50 1 100 0 1
./process.sh 5 250 1 100 0 1

./process.sh 10 1 1 100 0 1
./process.sh 10 5 1 100 0 1
./process.sh 10 10 1 100 0 1
./process.sh 10 50 1 100 0 1
./process.sh 10 500 1 100 0 1

#set 2
#coding rate: 100%
./process.sh 1 1 1 100 0 2
./process.sh 5 1 1 100 0 2
./process.sh 10 1 1 100 0 2

#coding rate: 75%
./process.sh 1 1 1 75 0 2
./process.sh 5 1 1 75 0 2
./process.sh 10 1 1 75 0 2

#coding rate: 50%
./process.sh 1 1 1 50 0 2
./process.sh 5 1 1 50 0 2
./process.sh 10 1 1 50 0 2

#coding rate: 25%
./process.sh 1 1 1 25 0 2
./process.sh 5 1 1 25 0 2
./process.sh 10 1 1 25 0 2


#precoding
./process.sh 1 1 1 100 1 3
./process.sh 1 5 1 100 1 3
./process.sh 1 10 1 100 1 3
./process.sh 1 50 1 100 1 3

./process.sh 5 1 1 100 1 3
./process.sh 5 5 1 100 1 3
./process.sh 5 10 1 100 1 3
./process.sh 5 50 1 100 1 3

./process.sh 10 1 1 100 1 3
./process.sh 10 5 1 100 1 3
./process.sh 10 10 1 100 1 3
./process.sh 10 50 1 100 1 3
