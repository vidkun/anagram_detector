require 'json'
require 'redis'

lookup_table = Redis.new(host: "0.0.0.0", port: 32768)

# read each line from stdin
$stdin.each_line do |l|

  # parse JSON to get fields and values
  line = JSON.parse(l.chomp)

  # massage the string and discard any non-alpha characters
  s = line['text'].downcase.chars
  current_string = s.keep_if { |v| v =~ /[a-z]/ }.sort.join

  if lookup_table.exists current_string
    # print out current line's id and the id of the last
    # matching anagram
    # puts lookup_table[current_string].join(', ')
    puts "#{lookup_table.get current_string}, #{line['id']}"

    # update redis set with most recent anagram id
    lookup_table.set current_string, line['id']
  else
    # add the current string as a new hash key and add
    # its id to the array of values for that key
    # lookup_table[current_string] = [ line['id'] ]
    lookup_table.set current_string, line['id']
  end
end

# cleanup redis db so we don't get false positives on subsequent runs
lookup_table.flushdb