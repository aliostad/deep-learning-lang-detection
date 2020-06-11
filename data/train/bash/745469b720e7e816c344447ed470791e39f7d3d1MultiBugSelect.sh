#!/bin/bash
#
# script to generate Bugzilla multi-select URL for batch processing from
# an input file that contains one bug number per line.
#######

# Input file 'buglist'
BUGFILE=buglist

# Number of bugs to process in a chunk
CHUNK=25

# URL parts from which to build the query (these do not change)
BEG='https://bugzilla.houston.hpecorp.net:1181/bugzilla/buglist.cgi?bug_id='
SEP='%2C'
ENDstr='&bug_id_type=anyexact&order=bug_id&query_format=advanced&tweak=1'

#
# function to create a cut/paste URL from accumulated bugs
#
function CreateURL() {
    # append most recently read bug number
    B=${B}${SEP}${b}
            #echo "wrote: ${b}" >> out
    echo "${j}/${t} === ${i} bugs in chunk === Last bug in this list: ${b}"
    echo -e "\t>>>>> Cut/Paste https:// line into Browser <<<<<\n"
    echo ${BEG}${B}${ENDstr}

    # comment for the commit
    echo -e "\n"'Move "Verified" bugs to "Closed"'

    B=''
    b=''
    # pause to cut/paste into browser
    read -p "PAUSE  " ans
    # clear screen
    clear
    # increment chunk count
    ((j+=1))
} # end CreateURL function

# number of lines in input file
k=$(wc -l ${BUGFILE}|awk '{print $1}')
# position in CHUNK
i=0
# Number of CHUNKs processed
j=1
# number of CHUNKs
((t=(k/CHUNK)))

# Loop through bug file
for b in $(< ${BUGFILE})
{
    #echo "read: ${b}" >> out
    ((i+=1))
    if ((i==CHUNK))
    then
        CreateURL ${B}
        i=0
    else
        if ((i==1))
        then
            B=${b}
            #echo "wrote: ${b}" >> out
            b=''
        else
            B=${B}${SEP}${b}
            #echo "wrote: ${b}" >> out
            b=''
        fi
    fi
    if ((${#b} > 0 ))
    then
        echo "dropped a bug: ${b}"
    fi
} # end of for b loop
CreateURL ${B}
