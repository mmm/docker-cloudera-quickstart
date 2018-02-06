#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y -q apt-utils
apt-get install -y -q openjdk-8-jre-headless wget dialog curl sudo lsof vim axel telnet
apt-get install -y -q uuid-runtime

curl -s http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/archive.key | apt-key add -
echo 'deb [arch=amd64] http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh xenial-cdh5 contrib' > /etc/apt/sources.list.d/cloudera.list
echo 'deb-src http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh xenial-cdh5 contrib' >> /etc/apt/sources.list.d/cloudera.list

apt-get update

apt-get -y install hadoop-conf-pseudo
sed -i 's/localhost/0.0.0.0/' /etc/hadoop/conf.pseudo/core-site.xml
apt-get -y install impala impala-server impala-state-store impala-catalog impala-shell

#CDH5-Installation-Guide Step 1 - Format the NameNode
echo "Step 1 - Format the NameNode"
sudo -u hdfs hdfs namenode -format

#CDH5-Installation-Guide Step 2 - Start HDFS
echo "Step 2 - Start HDFS"
bash -c 'for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done'

#CDH5-Installation-Guide Step 3 - Create the directories needed for Hadoop processes
echo "Step 3 - Create the directories needed for Hadoop processes"
/usr/lib/hadoop/libexec/init-hdfs.sh

#CDH5-Installation-Guide Step 4: Verify the HDFS File Structure
echo "Step 4: Verify the HDFS File Structure"
sudo -u hdfs hadoop fs -ls -R /

#CDH5-Installation-Guide Step 5 - Start Yarn
echo "Step 5 - Start Yarn"
service hadoop-yarn-resourcemanager start
service hadoop-yarn-nodemanager start
service hadoop-mapreduce-historyserver start

#CDH5-Installation-Guide Step 6 - Create User Directories
echo "Step 6 - Create User Directories"
sudo -u hdfs hadoop fs -mkdir /user/hadoop
sudo -u hdfs hadoop fs -chown hadoop /user/hadoop
hadoop fs -mkdir       /tmp
hadoop fs -mkdir       /user/hive/warehouse
hadoop fs -chmod g+w   /tmp
hadoop fs -chmod g+w   /user/hive/warehouse
sudo -u hdfs hadoop fs -mkdir /hbase
sudo -u hdfs hadoop fs -chown hbase /hbase

#CDH5-Installation-Guide Install HBase
echo "Install Cloudera Components"
apt-get -y install hive hbase hbase-thrift hbase-master pig hue oozie oozie-client 
apt-get -y install spark-core spark-master spark-worker spark-history-server spark-python
#apt-get -y install spark2-core spark2-master spark2-worker spark2-history-server spark2-python

#export SPARK_VERSION=2.2.0
#export SPARK_HADOOP_VERSION=2.7
#curl -OL http://www-us.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz
#tar xf spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz
#rm spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz

#Initiate Oozie Database
oozie-setup db create -run

create_hue_key() {
  local new_password=$1
  sed -i "s/secret_key=.*/secret_key=${new_password:0:15}/" /etc/hue/conf/hue.ini
}
create_hue_key `uuidgen`


