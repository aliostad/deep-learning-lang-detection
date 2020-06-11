#!/bin/sh
## palindrome.sh for palindrome in /home/boulogne_q/Piscine_Synthese/Projet-5/palindrome
## 
## Made by quentin boulogne
## Login   <boulogne_q@epitech.net>
## 
## Started on  Fri Jun 26 15:57:09 2015 quentin boulogne
## Last update Sat Jun 27 13:26:17 2015 quentin boulogne
##

#-> CHECK SI CES SUPPERRIEUR A UN INT <-
if [ ${1:-0} -gt 2147483646 ] || [ ${1:-0} -lt -2147483646 ]
then
    >&2 echo "overflow"
    exit
fi
if [ -n "$1" ] && [ -n "$2" ]
then
    number=$1
    numberOrigine=0
    base=$2
    boucle=0
    tourCmp=1
    
    #-> CHECK SI C'EST UN PALINDROME OU PAS <-
    checkPalin ()
    {
	numberSave=$number
	sd=0
	revNumber=""
	while [ $number -gt 0 ]
	do
	    sd=$(( $number % 10 ))
	    number=$(( $number / 10 ))
	    revNumber=$( echo ${revNumber}${sd} )
	done
	if [ $numberSave -eq $revNumber ];
	then
	    returnVal=1
	else
	    returnVal=0
	fi
    }
    
    #->CHECK SI LA BASE EST BIEN ENTRE 2 ET 10 <-
    if [ $base -gt 10 ] || [ $base -lt 2 ]
    then
	>&2 echo "argument invalide"
    fi
    
    if [ $base -eq 10 ]
    then
	numberOrigine=$number
	checkPalin
	if [ ${returnVal:-0} -eq 1 ]
	then
	    echo ${numberSave}" donne "${numberSave}" en 0 itération(s) (en base 10)"
	else
	    while [ ${boucle:-0} -lt 500000 ]
	    do
		numberRev=$(echo $numberSave | rev)
		number=`expr $numberSave + $numberRev`
		checkPalin
		if [ ${returnVal:-0} -eq 1 ]
		then
		    echo ${numberOrigine}" donne "${numberSave}" en " ${tourCmp}" itération(s) (en base 10)"
		    break
		fi
		boucle=`expr $boucle + 1`
		tourCmp=`expr $tourCmp + 1`
	    done
	fi
    fi
    
    if [ $base -eq 2 ]
    then
	numberOrigine=$number
	number=$( echo "obase=2; $number" | bc )
	checkPalin
	if [ ${returnVal:-0} -eq 1 ]
	then
	    numberSave=$( echo "ibase=2; obase=A; $numberSave" | bc )
	    echo ${numberSave}" donne "${numberSave}" en 0 itération(s) (en base 2)"
	else
	    while [ ${boucle:-0} -lt 500000 ]
	    do
		numberRev=$(echo $numberSave | rev)
		number=`expr $numberSave + $numberRev`
		checkPalin
		if [ ${returnVal:-0} -eq 1 ]
		then
		    numberSave=$( echo "ibase=2; obase=A; $numberSave" | bc )
		    echo ${numberOrigine}" donne "${numberSave}" en " ${tourCmp}" itération(s) (en base 2)"
		    break
		fi
		boucle=`expr $boucle + 1`
		tourCmp=`expr $tourCmp + 1`
	    done
	fi
    fi

    if [ $base -eq 3 ]
    then
	numberOrigine=$number
	number=$( echo "obase=3; $number" | bc )
	checkPalin
	if [ ${returnVal:-0} -eq 1 ]
	then
	    numberSave=$( echo "ibase=3; obase=A; $numberSave" | bc )
	    echo ${numberSave}" donne "${numberSave}" en 0 itération(s) (en base 3)"
	else
	    while [ ${boucle:-0} -lt 500000 ]
	    do
		numberRev=$(echo $numberSave | rev)
		number=`expr $numberSave + $numberRev`
		checkPalin
		if [ ${returnVal:-0} -eq 1 ]
		then
		    numberSave=$( echo "ibase=3; obase=A; $numberSave" | bc )
		    echo ${numberOrigine}" donne "${numberSave}" en " ${tourCmp}" itération(s) (en base 3)"
		    break
		fi
		boucle=`expr $boucle + 1`
		tourCmp=`expr $tourCmp + 1`
	    done
	fi	
    fi

    if [ $base -eq 4 ]
    then
	numberOrigine=$number
	number=$( echo "obase=4; $number" | bc )
	checkPalin
	if [ ${returnVal:-0} -eq 1 ]
	then
	    numberSave=$( echo "ibase=4; obase=A; $numberSave" | bc )
	    echo ${numberSave}" donne "${numberSave}" en 0 itération(s) (en base 4)"
	else
	    while [ ${boucle:-0} -lt 500000 ]
	    do
		numberRev=$(echo $numberSave | rev)
		number=`expr $numberSave + $numberRev`
		checkPalin
		if [ ${returnVal:-0} -eq 1 ]
		then
		    numberSave=$( echo "ibase=4; obase=A; $numberSave" | bc )
		    echo ${numberOrigine}" donne "${numberSave}" en " ${tourCmp}" itération(s) (en base 4)"
		    break
		fi
		boucle=`expr $boucle + 1`
		tourCmp=`expr $tourCmp + 1`
	    done
	fi	
    fi

    if [ $base -eq 5 ]
    then
	numberOrigine=$number
	number=$( echo "obase=5; $number" | bc )
	checkPalin
	if [ ${returnVal:-0} -eq 1 ]
	then
	    numberSave=$( echo "ibase=5; obase=A; $numberSave" | bc )
	    echo ${numberSave}" donne "${numberSave}" en 0 itération(s) (en base 5)"
	else
	    while [ ${boucle:-0} -lt 500000 ]
	    do
		numberRev=$(echo $numberSave | rev)
		number=`expr $numberSave + $numberRev`
		checkPalin
		if [ ${returnVal:-0} -eq 1 ]
		then
		    numberSave=$( echo "ibase=5; obase=A; $numberSave" | bc )
		    echo ${numberOrigine}" donne "${numberSave}" en " ${tourCmp}" itération(s) (en base 5)"
		    break
		fi
		boucle=`expr $boucle + 1`
		tourCmp=`expr $tourCmp + 1`
	    done
	fi	
    fi

    if [ $base -eq 6 ]
    then
	numberOrigine=$number
	number=$( echo "obase=6; $number" | bc )
	checkPalin
	if [ ${returnVal:-0} -eq 1 ]
	then
	    numberSave=$( echo "ibase=6; obase=A; $numberSave" | bc )
	    echo ${numberSave}" donne "${numberSave}" en 0 itération(s) (en base 6)"
	else
	    while [ ${boucle:-0} -lt 500000 ]
	    do
		numberRev=$(echo $numberSave | rev)
		number=`expr $numberSave + $numberRev`
		checkPalin
		if [ ${returnVal:-0} -eq 1 ]
		then
		    numberSave=$( echo "ibase=6; obase=A; $numberSave" | bc )
		    echo ${numberOrigine}" donne "${numberSave}" en " ${tourCmp}" itération(s) (en base 6)"
		    break
		fi
		boucle=`expr $boucle + 1`
		tourCmp=`expr $tourCmp + 1`
	    done
	fi	
    fi

    if [ $base -eq 7 ]
    then
	numberOrigine=$number
	number=$( echo "obase=7; $number" | bc )
	checkPalin
	if [ ${returnVal:-0} -eq 1 ]
	then
	    numberSave=$( echo "ibase=7; obase=A; $numberSave" | bc )
	    echo ${numberSave}" donne "${numberSave}" en 0 itération(s) (en base 7)"
	else
	    while [ ${boucle:-0} -lt 500000 ]
	    do
		numberRev=$(echo $numberSave | rev)
		number=`expr $numberSave + $numberRev`
		checkPalin
		if [ ${returnVal:-0} -eq 1 ]
		then
		    numberSave=$( echo "ibase=7; obase=A; $numberSave" | bc )
		    echo ${numberOrigine}" donne "${numberSave}" en " ${tourCmp}" itération(s) (en base 7)"
		    break
		fi
		boucle=`expr $boucle + 1`
		tourCmp=`expr $tourCmp + 1`
	    done
	fi	
    fi

    if [ $base -eq 8 ]
    then
	numberOrigine=$number
	number=$( echo "obase=8; $number" | bc )
	checkPalin
	if [ ${returnVal:-0} -eq 1 ]
	then
	    numberSave=$( echo "ibase=8; obase=A; $numberSave" | bc )
	    echo ${numberSave}" donne "${numberSave}" en 0 itération(s) (en base 8)"
	else
	    while [ ${boucle:-0} -lt 500000 ]
	    do
		numberRev=$(echo $numberSave | rev)
		number=`expr $numberSave + $numberRev`
		checkPalin
		if [ ${returnVal:-0} -eq 1 ]
		then
		    numberSave=$( echo "ibase=8; obase=A; $numberSave" | bc )
		    echo ${numberOrigine}" donne "${numberSave}" en " ${tourCmp}" itération(s) (en base 8)"
		    break
		fi
		boucle=`expr $boucle + 1`
		tourCmp=`expr $tourCmp + 1`
	    done
	fi	
    fi

    if [ $base -eq 9 ]
    then
	numberOrigine=$number
	number=$( echo "obase=9; $number" | bc )
	checkPalin
	if [ ${returnVal:-0} -eq 1 ]
	then
	    numberSave=$( echo "ibase=9; obase=A; $numberSave" | bc )
	    echo ${numberSave}" donne "${numberSave}" en 0 itération(s) (en base 9)"
	else
	    while [ ${boucle:-0} -lt 500000 ]
	    do
		numberRev=$(echo $numberSave | rev)
		number=`expr $numberSave + $numberRev`
		checkPalin
		if [ ${returnVal:-0} -eq 1 ]
		then
		    numberSave=$( echo "ibase=9; obase=A; $numberSave" | bc )
		    echo ${numberOrigine}" donne "${numberSave}" en " ${tourCmp}" itération(s) (en base 9)"
		    break
		fi
		boucle=`expr $boucle + 1`
		tourCmp=`expr $tourCmp + 1`
	    done
	fi	
    fi

else
    >&2 echo "argument invalide"
fi

