# Elasticsearch Docker Compose

## Overview
This directory contains a small Docker Compose stack that brings up a 4-node Elasticsearch cluster and an Nginx-based proxy that exposes a single, stable endpoint on the host (port 9200). The proxy performs active health checks against the four ES nodes and only routes traffic to nodes that respond.

## Contents (where to look)
- `docker-compose.yml` - defines the 4 ES services (`es01`..`es04`) and the `nginx-proxy` service.
- `nginx/` - Dockerfile and helper scripts used by the proxy:
  - `nginx/Dockerfile` - builds the nginx image with curl/bash.
  - `nginx/entrypoint.sh` - starts nginx and the healthcheck loop.
  - `nginx/healthcheck.sh` - probes upstream ES nodes, rewrites `/etc/nginx/conf.d/upstream.conf`, and reloads nginx when the healthy list changes.
  - `nginx/upstream.conf` - managed at runtime by the healthcheck script.

## Nginx proxy
- The proxy listens on host port 9200 and forwards requests to the healthy backend ES nodes.
- Health checks are performed by `healthcheck.sh` using simple HTTP requests (default `/`).
- Environment variables exposed to the proxy (in `docker-compose.yml`):
  - `UPSTREAM_NODES` - comma-separated list of `host:port` entries (default: `es01:9200,es02:9200,es03:9200,es04:9200`).
  - `CHECK_INTERVAL` - seconds between active checks (default 5).
  - `CHECK_TIMEOUT` - curl timeout in seconds for each check (default 2).

Notes:
- The proxy rewrites the nginx upstream configuration and reloads nginx when the healthy backends change. This is a lightweight approach for development/testing. For production, consider a full-featured load balancer.

## Elasticsearch context
- There are 4 Elasticsearch containers (`es01`..`es04`), each with its own data volume (`data01`..`data04`).
- Each ES node has an internal Docker healthcheck that checks its local HTTP endpoint.
- The cluster settings (seed hosts, initial master nodes, JVM options) are set via environment variables in `docker-compose.yml`.
- The ES containers are attached to a user-defined Docker network called `elastic` so the proxy can resolve container names (e.g. `es01`).

## Start (quick)
From this `elasticsearch` directory run:

```bash
# build images and start in background
docker-compose up --build -d

# follow logs (optional)
docker-compose logs -f nginx-proxy
```

The proxy will be available on the host at `http://localhost:9200` and will forward to healthy ES nodes.

## Teardown
To stop and remove containers, networks and volumes created by this compose file:

```bash
# stop and remove containers and network
docker-compose down

# optionally remove volumes (data will be deleted)
docker-compose down --volumes --remove-orphans
```

## Validations and troubleshooting
- Use the `Elastic validations` section below to run quick curl checks against the proxy endpoint (`localhost:9200`).
- If the proxy can't reach any ES nodes, requests to `localhost:9200` will fail; check `docker-compose logs nginx-proxy` and the `nginx/healthcheck.sh` output.

# HTTP Health checks
To access:
http://localhost:9200

To view health:
http://localhost:9200/_cat/health?v&pretty

To view health of nodes:
http://localhost:9200/_cat/nodes?v&pretty

# Elastic validations
```bash
curl -XGET 'localhost:9200/_cat/indices?v&pretty'

curl -XGET 'localhost:9200/_cat/nodes?v&pretty'

curl -XGET 'localhost:9200/_cat/health?v&pretty'
```

# Sample operations
```` bash
# creates index
curl -XPUT 'localhost:9200/products?&pretty'

# creates additional indices
curl -XPUT 'localhost:9200/customers?&pretty'
curl -XPUT 'localhost:9200/orders?&pretty'

# list indices
curl -XGET 'localhost:9200/_cat/indices?v&pretty'
````

# Adding docs
```` bash
# first mobile
curl -XPUT 'localhost:9200/products/product/1?pretty' -H 'Content-Type: application/json' -d'
{
    "type": "mobile",
    "name": "iPhone 7",
    "camera": "12MP",
    "storage": "256GB",
    "display": "4.7inch",
    "battery": "1,960mAh",
    "reviews": ["A happy comment", "Best phone", "Too expensive"] 
}
'

# 2nd mobile
curl -XPUT 'localhost:9200/products/product/2?pretty' -H 'Content-Type: application/json' -d'
{
    "type": "mobile",    
    "name": "Samsung Galaxy",
    "camera": "8MP",
    "storage": "128GB",
    "display": "5.2inch",
    "battery": "1,500mAh",
    "reviews": ["Best phone", "Love it"] 
}
'
# 3rd mobile
curl -XPUT 'localhost:9200/products/product/3?pretty' -H 'Content-Type: application/json' -d'
{
    "type": "mobile",    
    "name": "Xiaomi Note",
    "camera": "10MP",
    "storage": "128GB",
    "display": "5.5inch",
    "battery": "1,500mAh",
    "reviews": ["Great phone", "Too big"] 
}
'
# Laptops 
curl -XPUT 'localhost:9200/products/product/4?pretty' -H 'Content-Type: application/json' -d'
{
    "type": "laptop",
    "name": "Macbook Pro",
    "storage": "500GB",
    "RAM": "8GB",
    "display": "13inch",
    "os": "El Capitan",
    "reviews": ["great laptop", "another comment..."] 
}
'

curl -XPUT 'localhost:9200/products/product/5?pretty' -H 'Content-Type: application/json' -d'
{
    "type": "laptop",    
    "name": "Dell",
    "storage": "1TB",
    "RAM": "8GB",
    "display": "14inch",
    "os": "Windows 10",
    "reviews": ["great laptop", "light"] 
}
'

````

# Retrieving
```` bash
curl -XGET 'localhost:9200/products/product/1?pretty'
curl -XGET 'localhost:9200/products/product/1?pretty&_source=false'
curl -XGET 'localhost:9200/products/product/1?pretty&_source=name,reviews'
````
