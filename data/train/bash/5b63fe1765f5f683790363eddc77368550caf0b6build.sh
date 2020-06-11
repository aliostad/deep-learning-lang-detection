#!/bin/bash
repo='disqus/nginx'
tag='disqus-docker-nginx'
default='full'

for variant in light full openresty; do
    docker build --rm -t $tag ./python2/$variant
    for version in 2.7.10 2.7 2; do
        docker tag $tag $repo:python$version-$variant
        docker push $repo:python$version-$variant
    done
    if [ $variant == $default ]; then
        docker tag $tag $repo:python$version
        docker push $repo:python$version
    fi
    # onbuild versions
    docker build --rm -t $tag ./python2/$variant/onbuild
    for version in 2.7.10 2.7 2; do
        docker tag $tag $repo:python$version-$variant-onbuild
        docker push $repo:python$version-$variant-onbuild
    done
    if [ $variant == $default ]; then
        docker tag $tag $repo:python$version-onbuild
        docker push $repo:python$version-onbuild
    fi
done
