![Travis status](https://travis-ci.org/dalibor/blog.png)

# blog

* http://github.com/dalibor/blog


## DESCRIPTION:

Ruby on Rails blog application deployed at: [http://dalibornasevic.com](http://dalibornasevic.com)


## INSTALL:

- Clone repository

```
git clone git://github.com/dalibor/blog.git
cd blog
```

- Config database

```
cp config/database.yml.template config/database.yml
vi config/database.yml
```

- Config secret keys

```
cp config/config.yml.template config/config.yml
vim config/config.yml # edit config.yml file
```

- Change the secret token for verifying the integrity of signed cookies

```
First generate new secret token with: 'rake secret'
Then add it to config/initializers/secret_token.rb
```

- Install gems

```
bundle install
```

- Setup database

```
rake db:create
rake db:migrate
```

- Seed admin user

```
vi db/seeds.rb
rake db:seed
```

- Start the server

```
ruby script/server
```

- Run tests

```
rspec spec
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


## SEO

- When creating post fill description area for description meta tag of your show post page

- Add tags to the post which are used as keywords on the post page


## LICENSE:

(The MIT License)

Copyright (c) 2009-2012 Dalibor Nasevic

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
