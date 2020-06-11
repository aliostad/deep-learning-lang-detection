#!/bin/bash

func_error() {
  echo "Error installing"
  exit 1
}

[ -z "$1" ] && DESTDIR="/" || DESTDIR="$1"
[ -d "${DESTDIR}" ] || mkdir -p "${DESTDIR}" || func_error

cd "$(dirname "${BASH_SOURCE[0]}")"
# daemon and configuration
install -Dm755 "usr/bin/repo-check" "${DESTDIR}/usr/bin/repo-check" || func_error
install -Dm755 "usr/bin/repo-clear" "${DESTDIR}/usr/bin/repo-clear" || func_error
install -Dm755 "usr/bin/repo-daemon" "${DESTDIR}/usr/bin/repo-daemon" || func_error
install -Dm755 "usr/bin/repo-update" "${DESTDIR}/usr/bin/repo-update" || func_error
install -Dm755 "usr/bin/repo-sync" "${DESTDIR}/usr/bin/repo-sync" || func_error
install -Dm755 "usr/bin/repo-insert" "${DESTDIR}/usr/bin/repo-insert" || func_error
install -Dm644 "etc/repo-scripts.conf" "${DESTDIR}/etc/repo-scripts.conf" || func_error
install -Dm644 "usr/lib/systemd/system/repo-daemon.service" "${DESTDIR}/usr/lib/systemd/system/repo-daemon.service" || func_error

exit 0
