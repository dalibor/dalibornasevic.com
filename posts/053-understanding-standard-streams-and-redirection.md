---
id: 53
title: "Understanding standard streams and redirection"
date: 2015-03-08 00:41:00 +0100
author: Dalibor Nasevic
tags: [ruby, unix, streams]
---

Every process is initialized with 3 standard file descriptors:

* standard input
* standard output
* standard error

Standard input is read-only, while standard output and standard error are write-only.

In ruby we have both globals and constants to reference these streams:

```ruby
puts STDIN.object_id  == $stdin.object_id  # true
puts STDOUT.object_id == $stdout.object_id # true
puts STDERR.object_id == $stderr.object_id # true
```

The constants always point to the default streams, while globals can be changed to point to another I/O stream within the script.

Each file descriptor is represented by a number:

``` ruby
puts STDIN.fileno  # 0
puts STDOUT.fileno # 1
puts STDERR.fileno # 2
```

These numbers are what we use on command line when we redirect streams.

To demonstrate streams redirection, let's create few small ruby scripts (in the real world these would be any command line tools you use on daily basis). Create `in`, `out`, `err` and `outerr` files with following contents and make them executable with `chmod +x`:

```ruby
#!/usr/bin/env ruby

p "Standard input read: #{$stdin.read}"
```

```ruby
#!/usr/bin/env ruby

$stdout.puts 'out'
```

```ruby
#!/usr/bin/env ruby

$stderr.puts 'err'
```

```ruby
#!/usr/bin/env ruby

$stdout.puts 'out'
$stderr.puts 'err'
```

By default, both standard output and standard error are printed on the screen. Run:

```bash
./outerr

# out
# err
```

### Stream redirection

Redirect standard output to a file:

```bash
./out > file.txt
./out 1> file.txt # same thing

# cat file.txt 
# out
```

Redirect standard error to a file:

```bash
./err 2> file.txt

# cat file.txt 
# err
```

Redirect both standard output and standard error to a file:

```bash
./outerr &> file.txt

# cat file.txt 
# err
# out
```

Redirect standard error to standard output which is then redirected to a file:

```bash
./outerr > file.txt 2>&1

# cat file.txt 
# err
# out
```

Redirect standard output to standard error and then redirected to a file (nothing redirected):

```bash
./outerr > file.txt 1>&2

# cat file.txt
# file.txt is empty
```

Same applies for appending `>>`.

### Pipes and stream redirection

Same rules apply for pipes `|` as well, here are few examples to demonstrate that.

By default, only standard output is being passed over pipe:

```bash
./outerr | ./in

# err
# "Standard input read: out\n"
```

Redirect standard error to standard output:

```bash
./outerr 2>&1 | ./in

# "Standard input read: err\nout\n"
```

Redirect standard output to standard error:

```bash
./outerr 1>&2 | ./in

# "Standard input read: "
# out
# err
```
