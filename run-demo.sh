#!/bin/bash

export DOCKER_HOST_IP=$(ifconfig en0 | awk '/ *inet /{print $2}')

docker-compose up -d

LOGSTASH_CONTAINER=`docker-compose ps -q logstash`
KAFKA_CONTAINER=`docker-compose ps -q kafka`

docker exec -t -i $LOGSTASH_CONTAINER /opt/logstash/bin/logstash-plugin install logstash-input-kafka

docker exec -ti $KAFKA_CONTAINER /opt/kafka_2.11-0.8.2.1/bin/kafka-topics.sh --zookeeper localhost:2181  --create --topic tweets --partitions 1 --replication-factor 1
docker exec -ti $KAFKA_CONTAINER /opt/kafka_2.11-0.8.2.1/bin/kafka-topics.sh --zookeeper localhost:2181  --create --topic spark --partitions 1 --replication-factor 1

docker exec -ti $KAFKA_CONTAINER /opt/kafka_2.11-0.8.2.1/bin/kafka-topics.sh --zookeeper localhost:2181  --list

echo "Press CTRL-C to continue"

docker-compose logs -f

#read -n1 -r -s -p "Press key to terminate..." key

# Cleanup
docker-compose stop
docker-compose rm -f

