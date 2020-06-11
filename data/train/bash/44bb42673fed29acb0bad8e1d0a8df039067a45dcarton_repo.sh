#
# Package repository object
#
# Copyright (c) 2013 Red Hat, Inc. All rights reserved.
#
# This copyrighted material is made available to anyone wishing
# to use, modify, copy, or redistribute it subject to the terms
# and conditions of the GNU General Public License version 2.
#
# This program is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Free
# Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301, USA.

if [ -z "${_CARTON_REPO_SH+set}" ]; then
declare _CARTON_REPO_SH=

. carton_util.sh
. thud_misc.sh
. thud_arr.sh

# Load base repository parameters
# Args: dir
declare -r _CARTON_REPO_LOAD_BASE='
    declare -r dir="$1";       shift
    thud_assert "[ -d \"\$dir\" ]"

    declare -A repo=(
        [dir]="$dir"
        [hooks]="$dir/hooks"
        [rpm_link]="$dir/rpm"
        [rpm_old]="$dir/rpm.old"
        [rpm_cur]="$dir/rpm.cur"
        [rpm_log]="$dir/rpm.log"
    )
'

# Initialize a repo and output its string.
# Args: dir
# Output: repo string
function carton_repo_init()
{
    eval "$_CARTON_REPO_LOAD_BASE"
    mkdir "${repo[rpm_cur]}"
    createrepo --quiet "${repo[rpm_cur]}"
    ln -s "${repo[rpm_cur]}" "${repo[rpm_link]}"
    touch "${repo[rpm_log]}"
    thud_arr_print repo
}

# Load and output a repo string.
# Args: dir
# Output: repo string
function carton_repo_load()
{
    eval "$_CARTON_REPO_LOAD_BASE"
    thud_arr_print repo
}

# Get repo/revision pair from arguments
# Args: repo_str rev_str
declare -r _CARTON_REPO_GET_REPO_AND_REV='
    declare -r repo_str="$1"; shift
    declare -r rev_str="$1"; shift
    declare -A repo=()
    thud_arr_parse "repo" <<<"$repo_str"
    declare -A rev=()
    thud_arr_parse "rev" <<<"$rev_str"
'

# Check if a commit revision is published in a repo.
# Args: repo_str rev_str
function carton_repo_is_published()
{
    eval "$_CARTON_REPO_GET_REPO_AND_REV"
    declare f
    while read -r f; do
        if ! [ -e "${repo[rpm_link]}/$f" ]; then
            return 1
        fi
    done < <(
        find "${rev[rpm_dir]}" -name "*.rpm" -printf '%f\n'
    )
    return 0
}

# Update repo with a revision atomically, executing specified command with
# repo_str and rev_str arguments.
# Args: command repo_str rev_str
function _carton_repo_update()
{
    declare -r command="$1";    shift
    declare -r repo_str="$1";   shift
    declare -r rev_str="$1";    shift
    declare -A repo=()
    declare status
    thud_arr_parse repo <<<"$repo_str"

    set +o errexit
    (
        echo -n "Start: "
        date --rfc-2822
        set +o errexit
        (
            set -o errexit -o xtrace
            declare f
            shopt -s nullglob

            # Move to a copy of current repo atomically
            mkdir "${repo[rpm_old]}"
            cp -a "${repo[rpm_cur]}/repodata" "${repo[rpm_old]}"
            for f in "${repo[rpm_cur]}"/*.rpm; do
                ln "${repo[rpm_cur]}"/*.rpm "${repo[rpm_old]}"
                break
            done
            ln -s "${repo[rpm_old]}" "${repo[rpm_link]}".new
            mv -T "${repo[rpm_link]}"{.new,}

            # Update
            "$command" "$repo_str" "$rev_str"

            # Update metadata
            createrepo --update "${repo[rpm_cur]}"

            # Move to the updated repo atomically
            ln -s "${repo[rpm_cur]}" "${repo[rpm_link]}".new
            mv -T "${repo[rpm_link]}"{.new,}

            # Remove old repo
            rm -R "${repo[rpm_old]}"
        )
        status="$?"
        set -o errexit
        echo -n "End: "
        date --rfc-2822
        exit "$status"
    ) >| "${repo[rpm_log]}" 2>&1
    if [ -x "${repo[hooks]}/post-update" ]; then
        (
            cd "${repo[dir]}"
            "${repo[hooks]}/post-update" </dev/null >/dev/null || true
        )
    fi
}

# Add revision packages to a repo directory.
# Args: repo_str rev_str
function _carton_repo_add()
{
    eval "$_CARTON_REPO_GET_REPO_AND_REV"
    find "${rev[rpm_dir]}" -name "*.rpm" -print0 |
        xargs -0 cp -n -t "${repo[rpm_cur]}"
}

# Remove revision packages from a repo directory.
# Args: repo_str rev_str
function _carton_repo_del()
{
    eval "$_CARTON_REPO_GET_REPO_AND_REV"
    declare f
    while IFS= read -r f; do
        rm "${repo[rpm_cur]}/$f"
    done < <(
        find "${rev[rpm_dir]}" -name "*.rpm" -printf "%f\\n"
    )
}

# Publish a commit revision in a repo.
# Args: repo_str rev_str
function carton_repo_publish()
{
    declare -r repo_str="$1"; shift
    declare -r rev_str="$1"; shift
    thud_assert '! carton_repo_is_published "$repo_str" "$rev_str"'
    _carton_repo_update _carton_repo_add "$repo_str" "$rev_str"
}

# Withdraw (remove) a commit revision from a repo.
# Args: repo_str rev_str
function carton_repo_withdraw()
{
    declare -r repo_str="$1"; shift
    declare -r rev_str="$1"; shift
    thud_assert 'carton_repo_is_published "$repo_str" "$rev_str"'
    _carton_repo_update _carton_repo_del "$repo_str" "$rev_str"
}

fi # _CARTON_REPO_SH
