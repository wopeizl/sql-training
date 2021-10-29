#!/bin/zsh
CONTAINERS=$(docker-compose ps|tail -n +3|awk '{print $1}')
for i in $CONTAINERS
do
# echo $i
  IPADDR=$(docker inspect $i|grep -i ipaddress|grep 172|awk '{print $2}'|sed 's/"//'|Sed 's/",//')
#  echo $IPADDR

  if [ ! $IPADDR ]; then
    echo $i, "is not running"	  
  else
# append the ip hostname to hosts  
    for l in  $CONTAINERS
    do
     echo docker exec $l sh -c "echo $IPADDR $i >> /etc/hosts"
     docker exec $l sh -c "echo $IPADDR $i >> /etc/hosts"
    done;
  fi

done;


