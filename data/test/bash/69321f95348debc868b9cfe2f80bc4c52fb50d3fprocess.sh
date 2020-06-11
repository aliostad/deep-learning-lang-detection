# Outputs list of PIDs if processes are running

TMUX_POWERLINE_SEG_PROCESS_CMD_DEFAULT="pgrep -f cassandra.logdir"

generate_segmentrc() {
   read -d '' rccontents  << EORC
# Command for retrieving a list of PIDs to show
export TMUX_POWERLINE_SEG_PROCESS_CMD="${TMUX_POWERLINE_SEG_PROCESS_CMD_DEFAULT}"
EORC
   echo "$rccontents"
}

__process_settings() {
   if [ -z "$TMUX_POWERLINE_SEG_PROCESS_CMD" ]; then
      TMUX_POWERLINE_SEG_PROCESS_CMD="${TMUX_POWERLINE_SEG_PROCESS_CMD_DEFAULT}"
   fi
}
run_segment() {
   __process_settings
   local ret=""
   local sep=""
   for pid in $($TMUX_POWERLINE_SEG_PROCESS_CMD); do
      if [[ -n "$ret" ]]; then
         sep="¦"
      fi
      ret="${ret}${sep}${pid}"
   done;
   echo $ret

   return 0
}
