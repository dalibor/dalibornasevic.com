![Travis status](https://travis-ci.org/dalibor/dalibornasevic.com.png)

# dalibornasevic.com

* http://github.com/dalibor/dalibornasevic.com

## DESCRIPTION:

Personal website deployed at: [http://dalibornasevic.com](http://dalibornasevic.com)

## DEPENDENCIES:

```
sudo apt-get install libicu-dev
sudo apt-get install cmake
```

## INSTALL:

- Install gems

```
bundle install
```

- Start server

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
