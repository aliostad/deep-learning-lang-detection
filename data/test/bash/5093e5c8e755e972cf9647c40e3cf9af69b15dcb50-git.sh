## Copyright (c) 2014-2015 André Erdmann <dywi@mailerd.de>
##
## Distributed under the terms of the MIT license.
## (See LICENSE.MIT or http://opensource.org/licenses/MIT)
##

## int check_git_supported()
##
##  Returns 0 if running git commands is supported
##  (i.e. functions file built with PROG_GIT!=""
##  and PROG_GIT exists on the running system),
##  and 1 otherwise.
##
##
## ~int git_cmd ( *argv )
##
##  Runs a git command.
##
##
## int git_cmd_in_repo_dir ( *argv, **repo_dir )
##
##  Runs a git command in %repo_dir.
##  Equivalent to git_cmd -C <repo_dir> <argv>.
##
##
## int git_repo_checkout ( repo_dir, checkout_ref= )
##
##  Checks out a branch/tag/...
##  and performs a fast-forward merge (unless detached HEAD).
##
##
## int git_repo_update ( repo_dir, repo_uri, checkout_ref= )
##
##  Clones or updates a git repo dir and checks out the given ref.
##
##  Note: %repo_uri does not get added as new remote if %repo_dir exists,
##        instead changes are fetched from %repo_dir's default remote.
##
##
<% if PROG_GIT= %>
check_git_supported() { qwhich "@@PROG_GIT@@"; }

git_cmd() { "@@PROG_GIT@@" "${@}"; }

## git_cmd_in_repo_dir ( *args, **repo_dir )
git_cmd_in_repo_dir() { git_cmd -C "${repo_dir:?}" "${@}"; }

_git_rev_parse_in_repo_dir() {
   git_cmd_in_repo_dir rev-parse --quiet --verify "${@}" @@NO_STDOUT@@
}

_git_repo_checkout__try_merge_ff_only() {
   git_cmd_in_repo_dir symbolic-ref -q HEAD @@NO_STDOUT@@ || return 0
   veinfo "git: merge --ff-only"
   git_cmd_in_repo_dir merge -q --ff-only
}

## git_repo_checkout ( repo_dir, checkout_ref= )
##
git_repo_checkout() {
   <%% locals repo_dir checkout_ref %>
   repo_dir="${1-}"
   checkout_ref="${2-}"

   [ -n "${1-}" ] || return @@EX_USAGE@@

   git_cmd_in_repo_dir config merge.defaultToUpstream true || @@NOP@@

   case "${checkout_ref}" in
      "")
         _git_repo_checkout__try_merge_ff_only || return 4
      ;;

      */*)
         ewarn "Cannot checkout ${checkout_ref}"
         return 7
      ;;

      *)
         if _git_rev_parse_in_repo_dir "${checkout_ref}"; then
            # local branch or whatever
            veinfo "git: checking out ${checkout_ref}"

            git_cmd_in_repo_dir checkout -q "${checkout_ref}" || return 4
            _git_repo_checkout__try_merge_ff_only || return 4

         elif _git_rev_parse_in_repo_dir "origin/${checkout_ref}"; then
            veinfo "git: checking out ${checkout_ref} (origin/${checkout_ref})"

            git_cmd_in_repo_dir checkout -q \
               -b "${checkout_ref}" --track "origin/${checkout_ref}" || return 4

         else
            ewarn "Cannot checkout ${checkout_ref}"
            return 8
         fi
      ;;
   esac
}


_git_repo_update__fetch() {
   git_cmd_in_repo_dir fetch --tags "${@}"
}

_git_repo_update__clone() {
   _dodir_for_file_nonfatal "${repo_dir}" && \
   git_cmd clone "${@}" -- "${repo_uri}" "${repo_dir}"
}

## git_repo_update ( repo_dir, repo_uri, checkout_ref= )
##
git_repo_update() {
   <%%locals repo_uri repo_dir checkout_ref %>

   repo_dir="${1-}"
   repo_uri="${2-}"
   checkout_ref="${3-}"
   [ -n "${repo_uri}" ] && [ -n "${repo_dir}" ] || return @@EX_USAGE@@

   if _test_fs_lexists "${repo_dir}"; then
      if [ -d "${repo_dir}" ]; then
         if [ -d "${repo_dir}/.git" ]; then
            _git_repo_update__fetch || return ${?}

         elif _test_fs_dir_is_not_empty "${repo_dir}"; then
            ewarn "Cannot update non-git directory: ${repo_dir}"
            return 2

         else
            _git_repo_update__clone || return ${?}
         fi

      else
         ewarn "Cannot update non-git non-directory: ${repo_dir}"
         return 2
      fi

   else
      _git_repo_update__clone || return ${?}
   fi

   git_repo_checkout "${repo_dir}" "${checkout_ref}"
}

<% else %>
check_git_supported()  { return @@EX_NOT_SUPPORTED@@; }

git_cmd()              { return @@EX_NOT_SUPPORTED@@; }
git_cmd_in_repo_dir()  { return @@EX_NOT_SUPPORTED@@; }
git_repo_checkout()    { return @@EX_NOT_SUPPORTED@@; }
git_repo_update()      { return @@EX_NOT_SUPPORTED@@; }

<% endif %>



