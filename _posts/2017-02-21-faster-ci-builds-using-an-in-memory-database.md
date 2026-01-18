---
layout: post
title: "Faster CI builds using an in-memory database"
date: 2017-02-21 09:10:00 +0100
categories: [mysql, ubuntu, docker, ci]
summary: "Speed up your CI builds by using an in-memory database with tmpfs."
permalink: /posts/78-faster-ci-builds-using-an-in-memory-database
featured: true
---

What if you could get some speed improvement for your database intensive tests for free?

In this blog post we'll use an in-memory file storage called [tmpfs](https://en.wikipedia.org/wiki/Tmpfs) that is available on most Unix-like operating systems. To test this out I am using Ubuntu 14.04 and MySQL 5.5.54 but the approach applies to any database that writes data to disk. Databases are very sensitive to [IOPS](https://en.wikipedia.org/wiki/IOPS) since their job is reading and writing data and the speed gain comes from faster writes to RAM than disk.

You should expect to see more significant speed improvement if your test suite is more intense on the database like using database cleaning strategy with non-transactional fixtures, using truncation, etc. The gain depends on the speed difference between writing to RAM and writing to disk for your machine.

In my test, I got ~ **32%** speed improvement with build time decrease from **32.96** to **22.37** seconds:

```bash
# Before
Finished in 32.96 seconds (files took 3.38 seconds to load)
1316 examples, 0 failures, 1 pending

# After
Finished in 22.37 seconds (files took 3.29 seconds to load)
1316 examples, 0 failures, 1 pending
```

To test this out yourself and see what speed improvement you get, this is what to do.

### Create a RAM disk

Create a new directory `/mnt/testdisk` and then use the `mount` command to create a disk using `tmpfs` file storage with size of 300 megabytes.

```bash
sudo mkdir /mnt/testdisk
sudo mount -t tmpfs -o size=300m tmpfs /mnt/testdisk
```

In case you need to unmount and remove that directory later, you can do that with:

```bash
sudo umount /mnt/testdisk
sudo rm -rf /mnt/testdisk
```

### Run MySQL in Docker container

If you're not familiar with Docker you can skip this section. If you are familiar or you want to get familiar, first [install it](https://docs.docker.com/engine/installation/), and then just setup a MySQL container with the following command:

```bash
sudo docker run \
--detach \
--name=mysql-test \
--env="MYSQL_ROOT_PASSWORD=pass" \
--volume=/mnt/testdisk:/var/lib/mysql \
mysql:5.5.54
```

What that command does is, it creates a new MySQL container with a name of `mysql-test` using version `5.5.54`. It sets the root password for MySQL to `pass` and attaches the RAM disk we previously created at `/mnt/testdisk` to `/var/lib/mysql` that is the default MySQL datadir.

If the container was setup successfully, find out the IP address and check if MySQL is running inside:

```bash
sudo docker inspect mysql-test | grep "IPAddress"
# "IPAddress": "172.17.0.2",

mysql -uroot -ppass -h 172.17.0.2 -P 3306
```

If you can connect, then all is good and you are ready to change the host in `database.yml` for the test environment and measure the build time.

If something went wrong during container bootup, you can start debugging by checking out the container logs. I had an issue when I tried to use a smaller partition size for tmpfs disk and the container creation failed.

```bash
sudo docker logs mysql-test
```

In case you want to remove the container, you can do that with:

```bash
sudo docker rm -f mysql-test
```

### Configure local MySQL

If you're not familiar with Docker, the other option is to manually change the local MySQL config. The inconvenience is that you'll need to constantly change the config switching between development and test because RAM data will not persist after reboots. Here are setup steps.


Stop MySQL service:

```bash
sudo service mysql stop
```

Change MySQL data directory:

```bash
# sudo vi /etc/mysql/my.cnf
datadir	= /mnt/testdisk
```

Add apparmor (Linux kernel security module) alias for the new MySQL path:

```bash
# sudo vi /etc/apparmor.d/tunables/alias
alias /var/lib/mysql/ -> /mnt/testdisk,
```

Restart apparmor service:

```bash
sudo service apparmor restart

```

Re-configure MySQL to setup things properly in the new data directory:

```bash
sudo dpkg-reconfigure mysql-server-5.5
```

The last command will auto-start MySQL and then you should be ready to measure the test time.

Share in the comments what speed improvements do you get.
