#
# Repository list
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

if [ -z "${_CARTON_REPO_LIST_SH+set}" ]; then
declare _CARTON_REPO_LIST_SH=

. carton_util.sh
. carton_repo.sh
. thud_misc.sh

# Repository directory
declare -r CARTON_REPO_LIST_DIR="$CARTON_DATA_DIR/repo"

# Check if a string is a valid repo name.
# Args: str
function carton_repo_list_is_valid_name()
{
    carton_is_fs_name "$1"
}

# Output the list of repo names, one per line.
function carton_repo_list_list_repos()
{
    thud_assert "[ -d \"\$CARTON_REPO_LIST_DIR\" ]"
    ls "$CARTON_REPO_LIST_DIR"
}

# Get repo location arguments.
# Args: repo_name
declare -r _CARTON_REPO_LIST_GET_REPO_LOC='
    declare -r repo_name="$1";   shift
    thud_assert "carton_repo_list_is_valid_name \"\$repo_name\""
    thud_assert "[ -d \"\$CARTON_REPO_LIST_DIR\" ]"
    declare -r repo_dir="$CARTON_REPO_LIST_DIR/$repo_name"
'

# Check if a repository exists.
# Args: repo_name
function carton_repo_list_has_repo()
{
    eval "$_CARTON_REPO_LIST_GET_REPO_LOC"
    [ -e "$repo_dir" ]
}

# Add a new repository to the list and output its string.
# Args: repo_name
# Output: repo string
function carton_repo_list_add_repo()
{
    eval "$_CARTON_REPO_LIST_GET_REPO_LOC"
    thud_assert "! carton_repo_list_has_repo \"\$repo_name\""
    mkdir "$repo_dir"
    carton_repo_init "$repo_dir" "$@"
}

# Add a list of new repositories to the list.
# Args: repo_name...
function carton_repo_list_add_repo_list()
{
    if [ $# != 0 ]; then
        for repo_name in "$@"; do
            carton_repo_list_add_repo "$repo_name" >/dev/null
        done
    fi
}

# Get a repository string.
# Args: repo_name
# Output: repo string
function carton_repo_list_get_repo()
{
    eval "$_CARTON_REPO_LIST_GET_REPO_LOC"
    thud_assert "carton_repo_list_has_repo \"\$repo_name\""
    carton_repo_load "$repo_dir"
}

# Delete a repository.
# Args: repo_name
function carton_repo_list_del_repo()
{
    eval "$_CARTON_REPO_LIST_GET_REPO_LOC"
    thud_assert "carton_repo_list_has_repo \"\$repo_name\""
    rm -Rf -- "$repo_dir"
}

# Del a list of repositories from the list.
# Args: repo_name...
function carton_repo_list_del_repo_list()
{
    if [ $# != 0 ]; then
        for repo_name in "$@"; do
            carton_repo_list_del_repo "$repo_name" >/dev/null
        done
    fi
}

fi # _CARTON_REPO_LIST_SH
