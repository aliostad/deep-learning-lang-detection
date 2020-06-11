#!/bin/bash

function save_image() {
    IMAGE=$1
    TAR_FILE=$2
    echo "save_image($IMAGE, $TAR_FILE)"
    docker save -o $TAR_FILE $IMAGE
}

save_image "crazycode/jdk8-play23:latest" crazycode_jdk8-play23_latest.tar
save_image "crazycode/jdk8:latest" crazycode_jdk8_latest.tar
save_image "crazycode/buildpack-deps:latest" crazycode_buildpack-deps_latest.tar
save_image "crazycode/php5:latest" crazycode_php5_latest.tar
save_image "crazycode/elasticsearch:latest" crazycode_elasticsearch_latest.tar
save_image "crazycode/activemq:latest" crazycode_activemq_latest.tar
save_image "crazycode/rabbitmq:latest" crazycode_rabbitmq_latest.tar
save_image "crazycode/sphinx-doc:latest" crazycode_sphinx-doc_latest.tar
save_image "crazycode/sphinx-doc-fssm" debian_wheezy.tar
save_image "crazycode/pandoc:latest" crazycode_pandoc_latest.tar
save_image "crazycode/docbase:latest" crazycode_docbase_latest.tar
save_image "crazycode/jdk7:latest" crazycode_jdk7_latest.tar
save_image "crazycode/jdk6:latest" crazycode_jdk6_latest.tar
save_image "crazycode/memcached:latest" crazycode_memcached_latest.tar
save_image "crazycode/sqlplus:latest" crazycode_sqlplus_latest.tar
save_image "crazycode/zookeeper" crazycode_zookeeper.tar
save_image "nginx:latest" nginx_latest.tar
save_image "mysql:latest" mysql_latest.tar
save_image "redis:latest" redis_latest.tar
save_image "postgres:latest" postgres_latest.tar
save_image "debian:wheezy" debian_wheezy.tar
save_image "debian:latest" debian_wheezy.tar
