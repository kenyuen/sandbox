# Running Locally
````
docker-compose up -d

docker-compose down -v
````

To access:
http://localhost:9200

To view health:
http://localhost:9200/_cat/health?v&pretty

To view health of nodes:
http://localhost:9200/_cat/nodes?v&pretty


# Sample Operations
````
curl -XGET 'http://localhost:9200/_cat/indices?v&pretty'

curl -XGET 'localhost:9200/_cat/nodes?v&pretty'

````
