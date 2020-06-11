#!/bin/sh

repo-add /srv/ftp/archlinux/sergej-repo/i686/sergej-repo.db.tar.gz /srv/ftp/archlinux/sergej-repo/i686/*.pkg.tar.?z
repo-add /srv/ftp/archlinux/sergej-repo/x86_64/sergej-repo.db.tar.gz /srv/ftp/archlinux/sergej-repo/x86_64/*.pkg.tar.?z

repo-add -f /srv/ftp/archlinux/sergej-repo/i686/sergej-repo.files.tar.gz /srv/ftp/archlinux/sergej-repo/i686/*.pkg.tar.?z
repo-add -f /srv/ftp/archlinux/sergej-repo/x86_64/sergej-repo.files.tar.gz /srv/ftp/archlinux/sergej-repo/x86_64/*.pkg.tar.?z

./bin/my-own-repo-update.pl -i pacman dbi:SQLite:/srv/ftp/archlinux/sergej-repo/db/sergej-repo-i686.db /srv/ftp/archlinux/sergej-repo/i686/
./bin/my-own-repo-update.pl -i pacman dbi:SQLite:/srv/ftp/archlinux/sergej-repo/db/sergej-repo-x86_64.db /srv/ftp/archlinux/sergej-repo/x86_64/
