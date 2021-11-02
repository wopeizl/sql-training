#!/bin/zsh
CONTAINERS=$(docker-compose ps|tail -n +3|awk '{print $1}')
for i in $CONTAINERS
do
# echo $i
  IPADDR=$(docker inspect $i|grep -i ipaddress|grep -v Second|grep -v '"IPAddress": ""'|awk '{print $2}'|sed 's/"//'|sed 's/",//')
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

docker exec sql-client sed -iE 's/jobmanager.rpc.address:.*/jobmanager.rpc.address: jobmanager/g' /opt/flink/conf/flink-conf.yaml

