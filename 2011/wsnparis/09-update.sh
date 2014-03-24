# delete all data
curl -XDELETE localhost:9200/*

# index some data
curl -XPUT localhost:9200/test/type1/1 -d '{
  "tags" : ["scala", "functional"],
  "count" : 10,
  "price" : 12.5,
  "date" : "2011-05-25"
}'

curl -XPUT localhost:9200/test/type1/2 -d '{
  "tags" : ["clojure", "lisp", "functional"],
  "count" : 5,
  "price" : 15.7,
  "date" : "2011-05-26"
}'

curl -XPUT localhost:9200/test/type1/3 -d '{
  "tags" : ["java", "scala"],
  "count" : 5,
  "price" : 10.7,
  "date" : "2011-05-27"
}'

# Update one record
curl localhost:9200/test/type1/1/_update -d '{
  "doc" : {
    "price" : 11
  }
}'
curl localhost:9200/test/type1/1?pretty=1

# Bulk update
curl localhost:9200/test/type1/_bulk --data-binary '
{ "update" : {"_id" : "2"} }
{ "doc" : {"count" : 8} }
{ "update" : {"_id" : "3"} }
{ "doc" : {"date" : "2011-06-01", "price" : 13.75} }
'
curl -XGET localhost:9200/test/type1/2?pretty=1
curl -XGET localhost:9200/test/type1/3?pretty=1
