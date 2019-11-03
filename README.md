# README

## Installation

#### Requirements
* Ruby
* Postgresql
* Redis

#### Steps
```
# git clone repo_url
# cd csv_importer
# bundle install
# yarn install

// make sure you have the following env variables set
POSTGRES_HOST=localhost
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=csv_importer_dev
TEST_POSTGRES_DB=csv_importer_test

// Also you need config/master.key set. Contact me, to get its value

# bundle exec rails db:create db:migrate
# bundle exec rails s // starts the development server
# bundle exec sidekiq // starts sidekiq worker
```

#### Running tests
```
# RAILS_ENV=test bundle exec rails db:create db:create
# bundle exec rspec
```

#### Running rubocop
```
# bundle exec rubocp
```


### Running e2e tests
They are located in `e2e_tests` folder.
You need to have chromedriver installed

```
# cd e2e_tests
# bundle install
# bundle exec rspec
```
