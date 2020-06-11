## Copyright (c) 2015 André Erdmann <dywi@mailerd.de>
##
## Distributed under the terms of the MIT license.
## (See LICENSE.MIT or http://opensource.org/licenses/MIT)
##

<% if HAVE_IUCODE_TOOL %>

<% if DEFAULT_LOAD_CPU_IUCODE=1 %>
_cmdline_load_cpu_iucode=y
<% else %>
_cmdline_load_cpu_iucode=n
<% endif %>

parse_misc_cpu_iucode() {
   case "${key}" in
      cpu_iucode)
         if cmdline_value_bool_default_true; then
            _cmdline_load_cpu_iucode=y
         else
            _cmdline_load_cpu_iucode=n
         fi

         return 0
      ;;

      no_cpu_iucode)
         ## if cmdline_value_bool_default_false; then
         _cmdline_load_cpu_iucode=n
      ;;

   esac

   return 1
}

parse_misc_cpu_iucode_done() {
   ishare_set_flag want-load-cpu-iucode "${_cmdline_load_cpu_iucode}"
}

add_parser misc_cpu_iucode

<% endif %>
