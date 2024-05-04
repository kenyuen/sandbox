# Overview
Scribbles and snippets from the Data Stax course on Cassandra

https://academy.datastax.com/#/online-courses/6167eee3-0575-4d88-9f80-f2270587ce23 

# Playing with Docker Images
https://cassandra.apache.org/_/quickstart.html
``
# pull
docker pull cassandra:latest

# start
docker network create cassandra
docker run --rm -d --name cassandra --hostname cassandra --network cassandra cassandra

# Interact
docker run --rm -it --network cassandra nuvo/docker-cqlsh cqlsh cassandra 9042 --cqlversion='3.4.5'

# Cleanup
docker kill cassandra
docker network rm cassandra
``

# Create sample data
``
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
``
