#!/bin/bash
NODE_ID=${HOSTNAME:6}

echo "HOSTNAME: {$HOSTNAME} NODE_ID: {$NODE_ID}"
printenv

LISTENERS="PLAINTEXT://:9092,CONTROLLER://:9093"
ADVERTISED_LISTENERS="PLAINTEXT://kafka-$NODE_ID.$SERVICE:9092"
CONTROLLER_QUORUM_VOTERS=""
for i in $( seq 0 $REPLICAS); do
    if [[ $i != $REPLICAS ]]; then
        CONTROLLER_QUORUM_VOTERS="$CONTROLLER_QUORUM_VOTERS$i@kafka-$i.$SERVICE:9093,"
    else
        CONTROLLER_QUORUM_VOTERS=${CONTROLLER_QUORUM_VOTERS::-1}
    fi
done

echo "QUORUM = $CONTROLLER_QUORUM_VOTERS"

mkdir -p $SHARE_DIR/$NODE_ID
echo $CLUSTER_ID > $SHARE_DIR/cluster_id

sed -e "s+^node.id=.*+node.id=$NODE_ID+" \
-e "s+^controller.quorum.voters=.*+controller.quorum.voters=$CONTROLLER_QUORUM_VOTERS+" \
-e "s+^listeners=.*+listeners=$LISTENERS+" \
-e "s+^advertised.listeners=.*+advertised.listeners=$ADVERTISED_LISTENERS+" \
-e "s+^log.dirs=.*+log.dirs=$SHARE_DIR/$NODE_ID+" \
/opt/kafka/config/kraft/server.properties > server.properties.updated \
&& mv server.properties.updated /opt/kafka/config/kraft/server.properties
kafka-storage.sh format -t $CLUSTER_ID -c /opt/kafka/config/kraft/server.properties --ignore-formatted
exec kafka-server-start.sh /opt/kafka/config/kraft/server.properties