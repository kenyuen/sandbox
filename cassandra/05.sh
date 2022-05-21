# nodes; nodetool

./nodetool status
./nodetool info
./nodetool describecluster
./nodetool getlogginglevels
./nodetool setlogginglevel org.apache.cassandra TRACE

tail -f /var/log/cassandra/system.log

./nodetool settraceprobability 0.1

./nodetool drain
./nodetool stopdaemon

# restart cassandra

# stress test
cd /home/ubuntu/node/resources/cassandra/tools/bin/
./cassandra-stress write n=50000 no-warmup -rate threads=1

cd /home/ubuntu/node/resources/cassandra/bin
./nodetool flush

./nodetool status