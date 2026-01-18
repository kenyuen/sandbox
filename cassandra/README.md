# Overview
Scribbles and snippets from the [Data Stax course on Cassandra](https://academy.datastax.com/#/online-courses/6167eee3-0575-4d88-9f80-f2270587ce23)
 

# Playing with Docker Images
See this [blog](https://www.instaclustr.com/blog/running-apache-cassandra-single-and-multi-node-clusters-on-docker-with-docker-compose/?_bt=&_bk=&_bm=&_bn=x&_bg=&utm_term=&utm_campaign=&utm_source=adwords&utm_medium=ppc&hsa_acc=1467100120&hsa_cam=20756272281&hsa_grp=&hsa_ad=&hsa_src=x&hsa_tgt=&hsa_kw=&hsa_mt=&hsa_net=adwords&hsa_ver=3&gad_source=1&gclid=Cj0KCQjwudexBhDKARIsAI-GWYVXR3IsXEov4-_bPYe9gVeXZGF989kaleck2mAsyegnRtjK7slNYvkaAm78EALw_wcB)

Another from [github](https://github.com/thelastpickle/docker-cassandra-bootstrap/tree/master)

## Running the Container from Scratch
````commandline
# pull
docker pull cassandra:latest

# start
docker network create cassandra
docker run --rm -d --name cassandra --hostname cassandra --network cassandra cassandra

# Interact
docker run --rm -it --network cassandra nuvo/docker-cqlsh cqlsh cassandra 9042 --cqlversion='3.4.5'
docker exec -it cassandra cqlsh

# Cleanup
docker kill cassandra
docker network rm cassandra
````
## Running via docker-compose
````commandline
# startup
docker compose up -d

# check connection
docker exec -it cassandra1 cqlsh

# check cluster configuration
docker exec -it cassandra1 nodetool status

# check node info
docker exec -it cassandra1 nodetool info

# cleanup
docker compose down
````

## Create sample data
````sqlite-psql
-- Create a keyspace
CREATE KEYSPACE IF NOT EXISTS store WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : '1' };

-- Create a table
CREATE TABLE IF NOT EXISTS store.shopping_cart (
userid text PRIMARY KEY,
item_count int,
last_update_timestamp timestamp
);

-- Insert some data
INSERT INTO store.shopping_cart
(userid, item_count, last_update_timestamp)
VALUES ('9876', 2, toTimeStamp(now()));
INSERT INTO store.shopping_cart
(userid, item_count, last_update_timestamp)
VALUES ('1234', 5, toTimeStamp(now()));
````


## Connecting to Cassandra w/DBeaver
