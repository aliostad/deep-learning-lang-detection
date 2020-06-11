#!/bin/bash
source ~/.bash_colors
BLIST="${PWD}/bundle-list.txt"

# Checking for list of bundles url to exist
[ -e $BLIST ] || touch $BLIST
REPO_REGEXP='\(https\|git\|ssh\):\/\/\(.*\)\/\(.*\)\/\(.*\)'
declare -A repo_info

# This functions adds the url of the origin of a bundle git repository
is_repo(){
    echo $1 | grep -q "${REPO_REGEXP}" -  ;
    return $?
}

add_tolist(){ 
    #$1: repo_url 
    repo_url=$1
    is_repo $repo_url
    if [ $? -eq 0 ] 
    then
        grep -q $repo_url $BLIST || \
            echo -e "  URL: ${CGreen} ${repo_url} ${CNone} adding!" && \
            echo "${repo_url}" >> $BLIST
    fi
}
get_repo_info(){
    ORIGIN_URL=$1 
    REPO=$(echo $ORIGIN_URL |  sed -e "s/$REPO_REGEXP/\1 \2 \3 \4/g") 
    read -r -d '' -a  repo_array  <<< $REPO
    repo_info[protocol]=${repo_array[0]}
    repo_info[server]=${repo_array[1]}
    repo_info[user]=${repo_array[2]}
    repo_info[repo]=${repo_array[3]}
}

clone_repo(){
    ORIGIN_URL=$1 
    get_repo_info $ORIGIN_URL
    [ -d ./${repo_info[repo]} ] || mkdir ./${repo_info[repo]}
    git clone  $ORIGIN_URL ${repo_info['repo']}
}

upgrade(){
    ORIGIN_URL=$1
    cd  ${repo_info[repo]}
    msg="${CRed}>>>${CNone} Running ${CGreen}'git fetch'${CNone} for " 
    msg+="$CGreen${repo_info[repo]}$CNone from $CAqua${repo_info[server]}"
    echo -e
    git fetch 
    if [ $? = 0 ];
    then
        printf "${CRed}>>> ${CGreen}Fetch successful${CNone}\n";
        git pull ;
        cd .. ;
        return 0
    else
        echo "Could not fetch $ORIGIN_URL exiting"
        cd ..;
        return 1;
    fi
}

upgrade_repos(){
    n=1
    while read ORIGIN_URL  
    do 
        get_repo_info $ORIGIN_URL
        message="(${CGreen}${n}${CNone})"
        message+=" Upgrading bundle ${CAqua}${repo_info[repo]}"
        message+="${CNone} by ${CGreen}${repo_info[user]}"
        message+="${CNone} from ${CAqua}${repo_info[server]}${CNone}"
        echo -e  $message
        if [ ! -d ${repo_info[repo]} ] ;
        then 
            echo "cloning "$ORIGIN_URL
            clone_repo $ORIGIN_URL ;
        else
            echo "upgrading "${repo_info[repo]};
            upgrade $ORIGIN_URL;
        fi
        echo upgraded ${repo_info[repo]};
        #ORIGIN_URL=$(git remote show origin | grep Fetch | cut -c 14-) 
        n=$((n+1))
    done < ./bundle-list.txt
}

#ADD
if [ $1 = "-a" ]; 
then
#    get_repo_info $2
    add_tolist $2
    clone_repo $2
elif [ $1 = "-u" ];
then
    upgrade_repos;
else
    echo "Usage:"
    echo "    -a URL    adds a url to the list and clones the repo"
    echo "    -u        upgrades repos in the list"
fi
