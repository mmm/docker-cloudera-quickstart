# Docker Image for Cloudera Quickstart

Run the CDH Quick Start image in a docker container.

The latest CDH release is on `master`... pinned versions can be found on other
branches.


## Install

To run the docker-cdh image from docker-hub, simply use the following command:

    docker run -i svds/cdh

It's large, so you might want to do a separate

    docker pull svds/cdh

first.

## Use

Spin it up with 

    docker run -id svds/cdh

get the container id from

    docker ps

watch logs with

    docker logs -f <container_id>

attach with

    docker exec -it <container_id> bash -l

then run the usual cdh commands

    hadoop fs -ls /
    impala-shell
    hbase shell
    spark-submit

etc.


## Components

- Apache Hadoop (Common, HDFS, MapReduce, YARN)
- Apache HBase
- Apache ZooKeeper
- Apache Oozie
- Apache Hive
- Hue (Apache licensed)
- Apache Flume
- Cloudera Impala (Apache licensed)
- Apache Sentry
- Apache Sqoop
- Cloudera Search (Apache licensed)
- Apache Spark

## Links

Pull the image on Docker Hub: https://registry.hub.docker.com/u/svds/cdh

Github page: https://github.com/silicon-valley-data-science/docker-cdh

[Cloudera Documentation](http://www.cloudera.com/content/cloudera/en/documentation/core/latest/)


This image started life as a modified fork of
[caioquirino/docker-cloudera-quickstart](https://github.com/caioquirino/docker-cloudera-quickstart.git)
and is now curated by the Silicon Valley Data Science team.
