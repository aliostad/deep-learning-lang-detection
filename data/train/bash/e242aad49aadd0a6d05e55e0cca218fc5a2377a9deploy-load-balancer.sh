#!/bin/bash

ORG=inertialbox

docker images | grep "^${ORG}/nginx-load-balancer" > /dev/null 2>&1
[ $? -ne 0 ] && echo -e "\n===> Building image for the base load balancer.\n" &&\
  docker build -t ${ORG}/nginx-load-balancer nginx-load-balancer

docker images | grep "^${ORG}/load-balancer-one" > /dev/null 2>&1
[ $? -ne 0 ] && echo -e "\n===> Building image for load balancer ONE.\n" &&\
  docker build -t ${ORG}/load-balancer-one inertialbox/load-balancer-one

if [ -n "$REBUILD" ];then
  echo -e "\n===> Re-building image for the base load balancer.\n"
  docker build -t ${ORG}/nginx-load-balancer nginx-load-balancer

  echo -e "\n===> Re-building image for load balancer ONE.\n"
  docker build -t ${ORG}/load-balancer-one inertialbox/load-balancer-one

  docker ps -a | grep "[^\-\/]load-balancer-one" > /dev/null 2>&1
  [ $? -eq 0 ] && echo -e "\n===> Stopping and removing the load-balancer-one container.\n" &&\
    docker stop load-balancer-one > /dev/null 2>&1 &&\
    docker rm load-balancer-one > /dev/null 2>&1
fi

docker images | grep '<none>' > /dev/null 2>&1
[ $? -eq 0 ] && echo -e "\n===> Removing stale images.\n" &&\
  docker rmi $(docker images -qf dangling=true)

docker ps -a | grep "[^\-\/]load-balancer-one" > /dev/null 2>&1
[ $? -ne 0 ] && echo -e "\n===> Running load balancer ONE.\n" && \
  docker run -d --name load-balancer-one \
  -v /var/log/load-balancer-one/:/var/log/nginx/ \
  -p 80:80 ${ORG}/load-balancer-one

echo -e "\n===> Done.\n"
