![Travis status](https://travis-ci.org/dalibor/dalibornasevic.com.png)

# blog

* http://github.com/dalibor/dalibornasevic.com

## DESCRIPTION:

Ruby on Rails blog application deployed at: [http://dalibornasevic.com](http://dalibornasevic.com)

## DEPENDENCIES:

```
sudo apt-get install libicu-dev
sudo apt-get install cmake
```

## INSTALL:

- Clone repository

```
git clone git://github.com/dalibor/dalibornasevic.com.git
cd dalibornasevic.com
```

- Config secret keys

```
cp config/config.yml.template config/config.yml
vim config/config.yml # edit config.yml file
```

- Install gems

```
bundle install
```

- Start the server

```
rails s
```

- Run tests

```
bundle exec rspec spec
```


## DEPLOY

  - Setup production (run only once)

```
gitploy production setup
```

  - Deploy to production

```
gitploy production
```


## LICENSE:

(The MIT License)

Copyright (c) 2009-2016 Dalibor Nasevic

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
