#!/bin/bash

izip()
{
    local a1=($1)
    local a2=($2)
    local a3=($3)
    local i=0
    for v in ${a1[@]} ; do
        echo "$v ${a2[$i]} ${a3[$i]}"
        i="$((i+1))"
    done
}

if [ -z "${src_dir}" ]; then
    src_dir="${parent_src_dir}"
fi
    
if [ "${portz_keep_current_src}" != 1 ] ; then
    if  [ -d "${src_dir}" ] ; then
        inform "cleaning current sources ($src_dir)"
    fi
    rm -rf ${src_dir}
    mkdir -p ${src_dir}
fi

# fetch and unarchive
if [ -n "${svn_path}" ] ; then
    dir="${package_name}-trunk"
    if [ -n "${revision}" ] ; then
        svn_options="-r ${revision}"
        dir="${package_name}-r${revision}"
    fi
    (
        cd ${src_dir}
        portz_invoke svn co ${svn_options} ${svn_path} ${dir}
    )
elif [ -n "${mtn_url}" ] ; then
    if [ -z "${revision}" ] ; then
        echo "$package: mtn package is missing revision property"
        exit 1
    fi

    dir="${package_name}-r${revision}"
    db="${portz_archive}/${package_name}.mtn"
    if [ ! -f "$db" ] ; then
        portz_invoke mtn -d $db db init 
    fi
    portz_invoke mtn -d "$db" $mtn_options pull "$mtn_url"
    (
        cd "${src_dir}"
        portz_invoke mtn -d "${db}" checkout -r$revision ${dir}
    )
elif [ -n "${git_url}" ] ; then
    if [ -z "$git_tag" -a -z "$git_branch" -a -z "$git_ref" ] ; then
        if [ -n "$version" ] ; then
            git_tag="$version"
        fi
    fi
    repo="${portz_archive}/${package_name}.git"
    refspec=""
    dir="${src_dir}/${package_name}"

    if [ -n "$git_tag" ] ; then
        #refspec="refs/tags/$git_tag:refs/tags/$git_tag"
        git_ref="$git_tag"
    fi                  
    if [ ! -d "${repo}" ] ; then
        mkdir -p "${repo}"
        portz_invoke git init "${repo}"
        ( cd "$repo" ; git remote add origin "$git_url")
    fi
    log_info "in ${repo}"
    # ensure repo is up-to-date
    (
        cd "${repo}"
        git remote set-url origin "$git_url"
        portz_invoke git fetch origin   
    )
    # and checkout
    portz_invoke git clone -n --reference="$repo" "$git_url" "$dir"

    log_info "in ${dir}"
    ( 
        cd "$dir"
        portz_invoke git checkout "$git_ref"
    )
else
    fetch_src_temp_list=`bashfoo.mktemp`
    izip "$package_baseurl" "$sha1sum" > "$fetch_src_temp_list"
    while read url expected_sha1sum ; do
        archive_file="$(portz_fetch_url_with_cache $url)"
        inform archive_file="$archive_file"
        archive_sha1sum="$(portz_sha1sum "$archive_file")"
        #note, sha1sum works currently only
        # if there is only one archive
        if [ -n "$expected_sha1sum" ] ; then
            if [ "$expected_sha1sum" != "$archive_sha1sum" ] ; then
                log_info "error: bad checksum: expected $expected_sha1sum, found $archive_sha1sum ... aborting"
                exit 1
            else
                log_info "checksum (sha1) ok"
            fi
        else
            log_info "warning: package doesn't define sha1sum property: no integrity, authenticity check performed!"
        fi
        archive_files="$archive_files $archive_file"
        archive_sha1sums="$archive_sha1sums $archive_sha1sum"
    done < $fetch_src_temp_list
    if [ -z "$sha1sum" ] ; then
        sha1sum="$(echo $archive_sha1sums)"
    fi

    if [ -z "$stereotype" -o "$stereotype" = auto ] ; then
        rpm_file_re='\.rpm$'
        if [[ "${archive_files}" =~ $rpm_file_re ]] ; then
            log_info "file looks like rpm -> stereotype=rpm"
            stereotype=rpm
        fi
    fi

    portz_step ${TMP}/portz/${package_name}/src unarchive ${archive_files}
fi

