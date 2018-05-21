# Appointments management system

[![Build Status](https://travis-ci.org/iosadchiy/jetruby.svg?branch=master)](https://travis-ci.org/iosadchiy/jetruby)
[![Codecov](https://img.shields.io/codecov/c/github/iosadchiy/jetruby.svg)](https://codecov.io/gh/iosadchiy/jetruby)


## User stories

* As a user I can register in the system
* As a user I can see a list of my upcoming and past appointments
* As a user I can create new appointment and with as many reminders as I need
* As a user in the web interface I can see a list of submitted appointments through the API and confirm or cancel them
* As a guest, if I know user api key, I can post request to create appointment on a specific date with defined reminder
* As a quest, if I know user API key, I can receive the list of user appointments and filter it by date (let’s keep it simple, can specify only one day in params and receive appointments exactly during this day)
* As a system I should be able to monitor API usage and store general statistics per each user
* As a system I should be able to send reminders for appointments in the specified time


## Choice explanation

### User authentication

Google OAuth was chosen to reduce the number of actions required from the user and to simplify the implementation. The main alternatives to OAuth are the user/password authentication, HTTP Basic authentication, and more exotic methods like one-time passwords. A more secure approach could've been taken with JWT and hybrid client/server oAuth flow but it was considered an overkill. This flow can be implemented later if more strict security requirements are identified.

Only one authentication provider is supported. Multiple providers might be supported with an authentication framework (e.g. `devise`).

### Database

PostgreSQL was provided as a constraint.

### Job scheduling

ActiveJob with `sidekiq` backend was chosen. `ActiveJob` is the obvious choice since it satisfies our needs and comes with Rails out of the box. Multiple alternatives are available for backend (`delayed_job`, `resque`, default in-memory processing, etc). The in-memory processing wouldn't work as we need a separate worker dyno to process reminders. The others would work fine. Due to the use of Redis, `sidekiq` puts less load on the DB compared to `delayed_job` and is faster; but it's disadvantage is the additional dependency (on Redis).

The reminders are processed by the worker dyno. The `sidekiq-scheduler` gem is used to create periodic job that checks what reminders are ready to be sent. The SQL query used to identify those reminders has been optimized to use indices to make it efficient.

An alternative solution could be to schedule reminders as `ActiveJob`s with `wait_until` argument. But it complicates things in a distributed environment when no global clock is available which may lead to the reminder never being sent.

Since the app is hosted on free dynos, the worker will sleep after the web dyno has been inactive for 30 minutes, and no notifications will be sent.

### Stats collection

Stats are collected using `ActiveSupport::Notifications`. We're subscribing to the `process_action.action_controller` event and track average processing time per user per request type. The stats are stored to the DB, one row per user. The update does not have to touch any indexes, so it should be relatively cheap (no performance testing was executed though). For large traffic volume it might be better to use a key-value store to handle stats or delegate it to a 3rd party service.

### API response builder

Regular Rails controllers are used to process API requests (`Api::V1::AppointmentsController` inheriting from `ApiController`). The controller and the routes are namespaced which allows for easy versioning if need be.


## API

See your API key at https://jetruby-iosadchiy.herokuapp.com/profile

Get appointments, optionally filtered by date:

```
curl -H "Authorization: Token token=YOUR_API_KEY" "https://jetruby-iosadchiy.herokuapp.com/api/v1/appointments?date=2018-05-21"
```

Create an appointment:

```
curl -H "Authorization: Token token=YOUR_API_KEY" -X POST -d "appointment[title]=test appointment&appointment[starts_at]=2018-05-21 14:00" "https://jetruby-iosadchiy.herokuapp.com/api/v1/appointments"
```


## Deployment

The application can be seen in action here: https://jetruby-iosadchiy.herokuapp.com/


### Heroku

1. Create an application
2. Provision the addons: `heroku-postgresql`, `heroku-redis`, `sendgrid`
3. Set environment variables, e.g.:
```
APP_HOST='jetruby-iosadchiy.herokuapp.com'
DEFAULT_FROM_EMAIL='noreply@jetruby-iosadchiy.herokuapp.com'
GOOGLE_CLIENT_ID='xxx'
GOOGLE_CLIENT_SECRET='xxx'
MALLOC_ARENA_MAX=2
SECRET_KEY_BASE='xxx'
```
4. Add `heroku` origin and push to it

### Local development environment

1. Install Redis, PostgreSQL, and Heroku CLI
2. Run:
```
git clone https://github.com/iosadchiy/jetruby
cd jetruby
bundle install
```
3. Create `.env` file:
```
APP_HOST=localhost
GOOGLE_CLIENT_ID=xxx
GOOGLE_CLIENT_SECRET=xxx
MALLOC_ARENA_MAX=2
REDIS_URL=redis://127.0.0.1
DEFAULT_FROM_EMAIL=noreply@example.com
```
4. `rails db:setup`
5. `heroku local`
6. visit `http://localhost:5000`
