# vnodes

# check status
/home/ubuntu/node1/bin/dsetool status

# stop if running
/home/ubuntu/node1/resources/cassandra/bin/nodetool stopdaemon
/home/ubuntu/node2/resources/cassandra/bin/nodetool stopdaemon

# check configurations
ls /home/ubuntu/node1/data

# clear data directories on both nodes
rm -fr /home/ubuntu/node1/data/
rm -fr /home/ubuntu/node2/data/

# update cassandra.yaml
#   uncomment num_tokens to 128
#   comment out initial_token
vi /home/ubuntu/node1/resources/cassandra/conf/cassandra.yaml
vi /home/ubuntu/node2/resources/cassandra/conf/cassandra.yaml

# start up
/home/ubuntu/node1/bin/dse cassandra
/home/ubuntu/node2/bin/dse cassandra

# check that each node now has 128 tokens
/home/ubuntu/node1/resources/cassandra/bin/nodetool status

# check that each node are now responsible for smaller sections of the ring.
/home/ubuntu/node1/resources/cassandra/bin/nodetool ring

# stop if running
/home/ubuntu/node1/resources/cassandra/bin/nodetool stopdaemon
/home/ubuntu/node2/resources/cassandra/bin/nodetool stopdaemon

# check status
/home/ubuntu/node1/bin/dsetool status
