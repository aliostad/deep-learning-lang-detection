#!/usr/bin/env bash

# fail hard
set -o pipefail

# fail harder
set -eu

# Remove orphan PID files
if [ -f ./httpd.pid ]; then
    rm ./httpd.pid
fi

# Publish port
if [ ! -z ${PORT+x} ]; then
    echo "Booting on port $PORT..."
fi

# Start Apache 2.4
httpd -X -f dev/app.conf -d `pwd` \
    -C "LoadModule env_module $LIBEXECDIR/mod_env.so" \
    -C "LoadModule authz_core_module $LIBEXECDIR/mod_authz_core.so" \
    -C "LoadModule authz_host_module $LIBEXECDIR/mod_authz_host.so" \
    -C "LoadModule unixd_module $LIBEXECDIR/mod_unixd.so" \
    -C "LoadModule php5_module $LIBEXECDIR/libphp5.so" \
    -C "LoadModule dir_module $LIBEXECDIR/mod_dir.so"  \
    -C "LoadModule mime_module $LIBEXECDIR/mod_mime.so" \
    -C "LoadModule rewrite_module $LIBEXECDIR/mod_rewrite.so" \
    -C "LoadModule log_config_module $LIBEXECDIR/mod_log_config.so" \
    -C "Listen $PORT" -C "AddType application/x-httpd-php .php" \
    -C "DocumentRoot `pwd`/web/" \
    -DFOREGROUND
