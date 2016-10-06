This anagram dector reads in a JSON feed from STDIN, parses each line/entry, determines if it is an anagram of a previously seen line/entry, and if so prints out the IDs of the current entry and the last seen anagram of it.

To test it, I used the Faker gem to generate a JSON file of entries. Then I manually added in some entries that were known to be anagrams.

Here's an example of how to generate such a JSON file for testing.

```
irb(main):034:0> f = File.new('anagram_feeder.json', 'a+')
=> #<File:anagram_feeder.json>
irb(main):035:0> f << "{\"id\": #{Faker::Number.number(10)}, \"text\": \"Enlist\"}\n"
=> #<File:anagram_feeder.json>
irb(main):036:0> f << "{\"id\": #{Faker::Number.number(10)}, \"text\": \"Tinsel\"}\n"
=> #<File:anagram_feeder.json>
irb(main):037:0> 10000000.times { f << "{\"id\": #{Faker::Number.number(10)}, \"text\": \"#{Faker::Hipster.sentence(3)}\"}\n" }
=> 10000000
```


This script uses Redis as a backend to keep memory costs low. As such, you'll have to update line 4 to point to your own Redis instance. In my case, I just spun up a quick test instance in Docker locally.

`lookup_table = Redis.new(host: "<your_redis_host>", port: <your_redis_port>)`