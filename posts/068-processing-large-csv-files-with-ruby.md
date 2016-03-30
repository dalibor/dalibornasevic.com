---
id: 68
title: "Processing large CSV files with Ruby"
date: 2016-03-29 21:10:00 +0100
author: Dalibor Nasevic
tags: [csv, ruby]
---

Processing large files is a memory intensive operation and could cause servers to run out of RAM memory and swap to disk. Let's look at few ways to process CSV files with Ruby and measure the memory consumption and speed performance.


### Prepare CSV data sample

Before we start, let's prepare a CSV file `data.csv` with 1 million rows (~ 75 MB) to use in tests.

```ruby
require 'csv'
require_relative './helpers'

headers = ['id', 'name', 'email', 'city', 'street', 'country']

name    = "Pink Panther"
email   = "pink.panther@example.com"
city    = "Pink City"
street  = "Pink Road"
country = "Pink Country"

print_memory_usage do
  print_time_spent do
    CSV.open('data.csv', 'w', write_headers: true, headers: headers) do |csv|
      1_000_000.times do |i|
        csv << [i, name, email, city, street, country]
      end
    end
  end
end
```


### Memory used and time spent

This script above requires the `helpers.rb` script which defines two helper methods for measuring and printing out the memory used and time spent.

```ruby
require 'benchmark'

def print_memory_usage
  memory_before = `ps -o rss= -p #{Process.pid}`.to_i
  yield
  memory_after = `ps -o rss= -p #{Process.pid}`.to_i

  puts "Memory: #{((memory_after - memory_before) / 1024.0).round(2)} MB"
end

def print_time_spent
  time = Benchmark.realtime do
    yield
  end

  puts "Time: #{time.round(2)}"
end
```

The results to generate the CSV file are:

```bash
$ ruby generate_csv.rb
Time: 5.17
Memory: 1.08 MB
```

Output can vary between machines, but the point is that when building the CSV file, the Ruby process did not spike in memory usage because the garbage collector (GC) was reclaiming the used memory. The memory increase of the process is about 1MB, and it created a CSV file with size of 75 MB.

```bash
$ ls -lah data.csv
-rw-rw-r-- 1 dalibor dalibor 75M Mar 29 00:34 data.csv
```


### Reading CSV from a file at once (CSV.read)

Let's build a CSV object from a file (`data.csv`) and iterate with the following script:

```ruby
require_relative './helpers'
require 'csv'

print_memory_usage do
  print_time_spent do
    csv = CSV.read('data.csv', headers: true)
    sum = 0

    csv.each do |row|
      sum += row['id'].to_i
    end

    puts "Sum: #{sum}"
  end
end
```

The results are:

```bash
$ ruby parse1.rb
Sum: 499999500000
Time: 19.84
Memory: 920.14 MB
```

Important to note here is the big memory spike to 920 MB. That is because we build the whole CSV object in memory. That causes lots of String objects to be created by the CSV library and the used memory is much more higher than the actual size of the CSV file.


### Parsing CSV from in memory String (CSV.parse)

Let's build a CSV object from a content in memory and iterate with the following script:

```ruby
require_relative './helpers'
require 'csv'

print_memory_usage do
  print_time_spent do
    content = File.read('data.csv')
    csv = CSV.parse(content, headers: true)
    sum = 0

    csv.each do |row|
      sum += row['id'].to_i
    end

    puts "Sum: #{sum}"
  end
end
```

The results are:

```bash
$ ruby parse2.rb
Sum: 499999500000
Time: 21.71
Memory: 1003.69 MB
```

As we can see from the results, the memory increase is about the memory increase from the previous example plus the memory size of the file content that we read in memory (75MB).


### Parsing CSV line by line from String in memory (CSV.new)

Let's now see what happens if we load the file content in a String and parse it line by line:

```ruby
require_relative './helpers'
require 'csv'

print_memory_usage do
  print_time_spent do
    content = File.read('data.csv')
    csv = CSV.new(content, headers: true)
    sum = 0

    while row = csv.shift
      sum += row['id'].to_i
    end

    puts "Sum: #{sum}"
  end
end
```

The results are:

```bash
$ ruby parse3.rb
Sum: 499999500000
Time: 9.73
Memory: 74.64 MB
```

From the results we can see that the memory used is about the file size (75 MB) because the file content is loaded in memory and the processing time is about twice faster. This approach is useful when we have the content that we don't need to read it from a file and we just want to iterate over it line by line.


### Parsing CSV file line by line from IO object

Can we do any better than the previous script? Yes, if we have the CSV content in a file. Let's use an IO file object directly:

```ruby
require_relative './helpers'
require 'csv'

print_memory_usage do
  print_time_spent do
    File.open('data.csv', 'r') do |file|
      csv = CSV.new(file, headers: true)
      sum = 0

      while row = csv.shift
        sum += row['id'].to_i
      end

      puts "Sum: #{sum}"
    end
  end
end
```

The results are:

```bash
$ ruby parse4.rb
Sum: 499999500000
Time: 9.88
Memory: 0.58 MB
```

In the last script we see less than 1 MB of memory increase. Time seems to be a very little slower compared to previous script because there is more IO involved. The CSV library has a built in mechanism for this, `CSV.foreach`:

```ruby
require_relative './helpers'
require 'csv'

print_memory_usage do
  print_time_spent do
    sum = 0

    CSV.foreach('data.csv', headers: true) do |row|
      sum += row['id'].to_i
    end

    puts "Sum: #{sum}"
  end
end
```

The results are similar:

```ruby
$ ruby parse5.rb
Sum: 499999500000
Time: 9.84
Memory: 0.53 MB
```

Imagine you need to process large CSV files of 10GB or more. Deciding to use the last strategy seems obvious.
