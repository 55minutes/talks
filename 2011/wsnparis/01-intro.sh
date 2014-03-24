# Delete all the data
curl -XDELETE localhost:9200/*

# Index Some Data, one by one
curl localhost:9200/wsnparis/talk?pretty=1 -d '{
  "speaker" : "Adrian Colyer",
  "title" : "Enterprise Applications in 2011 Challenges in Development and Deployment, and Springs response"
}'

curl localhost:9200/wsnparis/talk -d '{
  "speaker" : "Boris Bokowski",
  "title" : "Introducing Orion: Embracing the Web for Software Development Tooling"
}'

curl localhost:9200/wsnparis/talk -d '{
  "speaker" : "Howard Lewis Ship",
  "title" : "Towards the Essence of Programming"
}'

# Bulk index
curl localhost:9200/wsnparis/talk/_bulk --data-binary '
  { "index" : {} }
  { "speaker" : "Jevgeni Kabanov", "title" : "Do you really get memory?" }
  { "index" : {} }
  { "speaker" : "Jags Ramnarayan", "title" : "SQLFabric - Scalable SQL instead of NoSQL" }
  { "index" : {} }
  { "speaker" : "Brad Drysdale", "title" : "HTML5 WebSockets : the Web Communication revolution, making the impossible possible" }
  { "index" : {} }
  { "speaker" : "Neal Gafter", "title" : "" }
  { "index" : {} }
  { "speaker" : "Rob Harrop", "title" : "Multi-Platform Messaging with RabbitMQ" }
  { "index" : {} }
  { "speaker" : "Theo Schlossnagle", "title" : "Service Decoupling in Carrier-Class Architectures" }
  { "index" : {} }
  {  "speaker" : "Michaël Chaize", "title" : "Architecting user-experiences" }
  { "index" : {} }
  { "speaker" : "Jonas Bonér", "title" : "Akka: Simpler Scalability, Fault-Tolerance, Concurrency & Remoting through Actors" }
  { "index" : {} }
  { "speaker" : "Shay Banon", "title" : "ElasticSearch - A Distributed Search Engine" }
  { "index" : {} }
  { "speaker" : "Kohsuke Kawaguchi", "title" : "Taking Continuous Integration to the next level with Jenkins" }
'

# Simple Search
curl 'localhost:9200/_count?q=*&pretty=1'

curl 'localhost:9200/_search?q=scalability&pretty=1'

curl 'localhost:9200/_search?q=speaker:Adrian&pretty=1'

curl 'localhost:9200/_search?q=_missing_:title&pretty=1'

# What's the difference between index and create?
curl localhost:9200/wsnparis/talk/ben -d '{
  "speaker" : "Benjamin Pack",
  "title" : "Towards a Harmonious Workplace"
}'
curl localhost:9200/wsnparis/talk/ben?pretty=1

## Now let's change it
curl localhost:9200/wsnparis/talk/ben -d '{
  "speaker" : "Benjamin Pack",
  "title" : "Towards a Caring Workplace"
}'
# Notice the version number has been incremented
curl localhost:9200/wsnparis/talk/ben?pretty=1

# Now let's try to use create, errors out
curl localhost:9200/wsnparis/talk/ben/_create -d '{
  "speaker" : "Benjamin Pack",
  "title" : "Towards a Sarcastic Workplace"
}'
# No changes
curl localhost:9200/wsnparis/talk/ben?pretty=1
