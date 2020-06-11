# ~/.local/ProfileX/share/prompt/load.sh
#
# AUTHOR     Snakevil Zen <zsnakevil@gmail.com>
# COPYRIGHT  © 2011 Snakevil.in.

'which' awk sed uptime > /dev/null && {
  _PROFILEX_LOAD=`'uptime' \
    | 'awk' -F'load average' '{print $2}' \
    | 'awk' -F',' '{print $1}' \
    | 'awk' '{print $2}'`
  'which' expr > /dev/null && {
    'expr' "${_PROFILEX_LOAD}" \> 0.1 > /dev/null && {
      'expr' "${_PROFILEX_LOAD}" \> 1 > /dev/null && {
        _PROFILEX_LOAD="${CMaroon}${CUnder}${_PROFILEX_LOAD}"
      } || {
        _PROFILEX_LOAD="${COlive}${CUnder}${_PROFILEX_LOAD}"
      }
    } || {
      _PROFILEX_LOAD="${CGreen}${CUnder}${_PROFILEX_LOAD}"
    }
  } || {
    _PROFILEX_LOAD="${CSilver}${CUnder}${_PROFILEX_LOAD}"
  }
  _PROFILEX_LOAD=" L${_PROFILEX_LOAD}"
}

# vim:ft=sh:fenc=utf-8:ff=unix:tw=75:ts=2:sts=2:et:ai:si
# vim:nowrap:sw=2:nu:nuw=4:so=5:fen:fdm=marker
