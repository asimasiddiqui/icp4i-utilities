#!/bin/bash

# oc login
oc login -u=admin -p=Passw0rd!

# Gracefully shutdown Aspera CP4I instance
REPLICAS=0
NAMESPACE=aspera

oc scale deploy aspera-1-aspera-hsts-aej                 --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy aspera-1-aspera-hsts-ascp-loadbalancer   --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy aspera-1-aspera-hsts-ascp-swarm          --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy aspera-1-aspera-hsts-http-proxy          --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy aspera-1-aspera-hsts-node-api            --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy aspera-1-aspera-hsts-node-master         --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy aspera-1-aspera-hsts-noded-loadbalancer  --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy aspera-1-aspera-hsts-noded-swarm         --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy aspera-1-aspera-hsts-prometheus-endpoint --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy aspera-1-aspera-hsts-stats               --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy aspera-1-aspera-hsts-tcp-proxy           --replicas=$REPLICAS -n $NAMESPACE
oc scale statefulset aspera-1-redis-ha-sentinel          --replicas=$REPLICAS -n $NAMESPACE
oc scale statefulset aspera-1-redis-ha-server            --replicas=$REPLICAS -n $NAMESPACE

sleep 5

oc delete pods --all -n $NAMESPACE --force --grace-period=0

# Gracefully shutdown Asset Repo CP4I instance
REPLICAS=0
NAMESPACE=integration

oc scale deploy assetrepo-1-asset-files-api               --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy assetrepo-1-catalog-api                   --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy assetrepo-1-clt-haproxy          --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy assetrepo-1-dc-main          --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy assetrepo-1-portal-catalog            --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy assetrepo-1-portal-common-api         --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy assetrepo-1-redis-ha-sentinel  --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy assetrepo-1-redis-ha-server         --replicas=$REPLICAS -n $NAMESPACE
oc scale sts assetrepo-1-clt-db --replicas=$REPLICAS -n $NAMESPACE
sleep 5

# Gracefully shutdown Event Streams CP4I instance

NAMESPACE=eventstreams

oc scale deploy es-1-ibm-es-access-controller-deploy  --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy es-1-ibm-es-collector-deploy          --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy es-1-ibm-es-indexmgr-deploy           --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy es-1-ibm-es-proxy-deploy              --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy es-1-ibm-es-rest-deploy               --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy es-1-ibm-es-rest-producer-deploy      --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy es-1-ibm-es-rest-proxy-deploy         --replicas=$REPLICAS -n $NAMESPACE
oc scale deploy es-1-ibm-es-ui-deploy                 --replicas=$REPLICAS -n $NAMESPACE
oc scale sts es-1-ibm-es-elastic-sts          --replicas=$REPLICAS -n $NAMESPACE
oc scale sts es-1-ibm-es-kafka-sts            --replicas=$REPLICAS -n $NAMESPACE
oc scale sts es-1-ibm-es-schemaregistry-sts   --replicas=$REPLICAS -n $NAMESPACE
oc scale sts es-1-ibm-es-zookeeper-sts        --replicas=$REPLICAS -n $NAMESPACE

sleep 12
#make all nodes unschedulable and drain pods

#oc adm cordon node1 
#oc adm cordon node2 
#oc adm cordon node3
#oc adm cordon node4
#oc adm cordon node5
#oc adm cordon node6
#oc adm cordon node7
#oc adm cordon common

#oc adm drain --ignore-daemonsets --delete-local-data --force --grace-period=30 node1
#oc adm drain --ignore-daemonsets --delete-local-data --force --grace-period=30 node2
#oc adm drain --ignore-daemonsets --delete-local-data --force --grace-period=30 node3
#oc adm drain --ignore-daemonsets --delete-local-data --force --grace-period=30 node4
#oc adm drain --ignore-daemonsets --delete-local-data --force --grace-period=30 node5
#oc adm drain --ignore-daemonsets --delete-local-data --force --grace-period=30 node6
#oc adm drain --ignore-daemonsets --delete-local-data --force --grace-period=30 node7 
#oc adm drain --ignore-daemonsets --delete-local-data --force --grace-period=30 common

exit 0
