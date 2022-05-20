# Running Locally
````
docker-compose up -d

docker-compose down -v
````

# HTTP Health checks
To access:
http://localhost:9200

To view health:
http://localhost:9200/_cat/health?v&pretty

To view health of nodes:
http://localhost:9200/_cat/nodes?v&pretty

# cURL Operations
```` bash
curl -XGET 'localhost:9200/_cat/indices?v&pretty'

curl -XGET 'localhost:9200/_cat/nodes?v&pretty'

curl -XGET 'localhost:9200/_cat/health?v&pretty'
````

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
