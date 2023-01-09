# Final Year Project: Integration of Educational Games in Educational Platforms

A web application developed using Ruby on Rails.

### Local Setup
#### Requirements
* Ruby 2.5.3
* Rails 6.1.6.1
* PostgreSQL 10.16
* Redis server 4.0.9
* Bundler 2.1.4

#### 1. Clone the project.
```bash
$ git clone https://github.com/JonathanYap97/iegep-fyp.git
```

#### 2. Install the gems.
```bash
$ cd iegep-fyp
$ bundle install
```

#### 3. Setup the database.
Edit [`database.yml`](https://github.com/JonathanYap97/iegep-fyp/blob/f84e155357f2afbd2d59b65c2523f0222594d205/config/database.yml) and add your database details under `development`. For example:
```yml
development:
  <<: *default
  database: iegep-fyp
  username: <%= ENV['iegep-fyp-database-user'] %>
  password: <%= ENV['iegep-fyp-database-password'] %>
  host: localhost
  port: 5432  
```

Next, create the database and migrate the models.
```bash
$ rails db:create
$ rails db:migrate
```

#### 4. Boot up the necessary services.
```bash
$ sudo service postgresql start
$ sudo service redis-server start
```

#### 5. Boot up the web application.
```bash
$ rails s
```
You may now access the web application on any web browser through the following URL:
```url
localhost:3000
```
