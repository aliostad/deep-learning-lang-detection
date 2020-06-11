work_dir=.
repo=rj-aur
repo_path=/media/big/aur-repo
repo_bak_path=/media/big/aur-bak
remote_path=rj-aur


do_add(){
    pkg=$2
    arch=$1
    echo "adding $pkg with arch=$arch ..."
    cp -v -f ${pkg} ${repo_path}/$arch
    cp -v -f ${pkg}.sig ${repo_path}/$arch
    cur_pwd=$PWD
    if [ "$arch" == "any" ]; then
        for ah in x86_64 i686 armv6h armv7h
        do
            repo-add ${repo_path}/${ah}/${repo}.db.tar.gz ${pkg}
            cd ${repo_path}/${ah} && ln -s -v -f ../any/${pkg} .
            cd ${repo_path}/${ah} && ln -s -v -f ../any/${pkg}.sig .
        done
        cd ${cur_pwd}
    else
        repo-add ${repo_path}/${arch}/${repo}.db.tar.gz ${pkg}
    fi
}

do_scan() {

    for arch in any x86_64 i686 armv6h armv7h
    do
        for ext in pkg.tar pkg.tar.xz
        do
            echo "trying to find ${arch}.${ext} files "
            find ${work_dir} -name \*${arch}.${ext} -exec update-repo.sh add ${arch} \{\} \;
        done
    done

    cd ${repo_path} && rsync -avP --delete . repo-S:${remote_path}
}
do_restore(){
    echo "restore repo with rsync..."
    rsync -avP --delete ${repo_bak_path} ${repo_path}
}
do_backup(){
    echo "backup exsiting repo with rsync..."
    rsync -avP --delete ${repo_path} ${repo_bak_path}
}

if [ "$1" == "add" ]; then
do_add $2 $3
elif [ "$1" == "restore" ]; then
do_restore
elif [ "$1" == "backup" ]; then
do_backup
else
do_scan
fi
