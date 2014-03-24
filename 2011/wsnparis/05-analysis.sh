# delete all data
curl -XDELETE localhost:9200/*

# create an index so we can play with it
curl -XPUT localhost:9200/test

# whitespace analysis of sample text
# whitespace analyzer
#    tokenizer -> whitespace
curl 'localhost:9200/test/_analyze?analyzer=whitespace&pretty=1' -d 'The quick brown fox jumped over the lazy dog'
# simple analyzer
#    tokenizer -> lowercase (divides text at non-letters and lowercase them)
curl 'localhost:9200/test/_analyze?analyzer=simple&pretty=1' -d 'The quick brown fox jumped over the lazy dog'
# stop analyzer:
#    tokenizer -> lowercase
#    filter -> [lowercase, stop]
curl 'localhost:9200/test/_analyze?analyzer=stop&pretty=1' -d 'The quick brown fox jumped over the lazy dog'
# keyword analyzer:
#   tokenizer -> keyword
curl 'localhost:9200/test/_analyze?analyzer=keyword&pretty=1' -d 'The quick brown fox jumped over the lazy dog'

curl -XDELETE localhost:9200/*
# custom analysis
# you have to install the phonetic analysis plugin first from
# <https://github.com/elasticsearch/elasticsearch-analysis-phonetic>. Follow
# the instructions there.
curl -XPUT localhost:9200/test -d '{
  "settings" : {
    "index" : {
      "analysis" : {
        "analyzer" : {
          "key_lowercase" : {
            "tokenizer" : "keyword",
            "filter" : "lowercase"
          },
          "ngram" : {
            "tokenizer" : "standard",
            "filter" : ["standard", "lowercase", "stop", "ngram"]
          },
          "soundex" : {
            "tokenizer" : "whitespace",
            "filter" : ["soundex"]
          }
        },
        "filter" : {
          "soundex" : {
            "type" : "phonetic",
            "encoder" : "soundex"
          },
          "ngram" : {
            "type" : "ngram",
            "min_gram" : 2,
            "max_gram" : 4
          }
        }
      }
    }
  }
}'

# use the key_lowercase analyzer
curl 'localhost:9200/test/_analyze?analyzer=key_lowercase&pretty=1' -d 'The quick brown fox jumped over the lazy dog'
# use the ngram analyzer
curl 'localhost:9200/test/_analyze?analyzer=ngram&pretty=1' -d 'The quick brown fox jumped over the lazy dog'
# use the soundex analyzer
curl 'localhost:9200/test/_analyze?analyzer=soundex&pretty=1' -d 'The quick brown fox jumped over the lazy dog'


# Use analyzers in mappings
# -> Note the text3 multi_field option
curl -XPUT localhost:9200/test/type1/_mapping -d '{
  "type1" : {
    "properties" : {
      "text1" : {
        "type" : "string",
        "analyzer" : "simple"
      },
      "text2" : {
        "type" : "string",
        "index_analyzer" : "simple",
        "search_analyzer" : "standard"
      },
      "text3" : {
        "type" : "string",
        "analyzer" : "standard",
        "fields" : {
          "ngram" : {
            "type" : "string",
            "analyzer" : "ngram"
          },
          "soundex" : {
            "type" : "string",
            "analyzer" : "soundex"
          }
        }
      }
    }
  }
}'

# Index sample data (just with text3)
curl -XPUT localhost:9200/test/type1/1 -d '{
  "text3" : "The quick brown fox jumped over the lazy dog"
}'

# search for quik (note that its not quick) using differen text3 fields
curl 'localhost:9200/test/_search?q=text3:quik&pretty=1'
curl 'localhost:9200/test/_search?q=text3.ngram:quik&pretty=1'
curl 'localhost:9200/test/_search?q=text3.soundex:quik&pretty=1'

# search for dawg (note that its not dog) using differen text3 fields
curl 'localhost:9200/test/_search?q=text3:dawg&pretty=1'
curl 'localhost:9200/test/_search?q=text3.ngram:dawg&pretty=1'
curl 'localhost:9200/test/_search?q=text3.soundex:dawg&pretty=1'
