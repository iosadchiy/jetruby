# Appointments management system

[![Build Status](https://travis-ci.org/iosadchiy/jetruby.svg?branch=master)](https://travis-ci.org/iosadchiy/jetruby)
[![Codecov](https://img.shields.io/codecov/c/github/iosadchiy/jetruby.svg)](https://codecov.io/gh/iosadchiy/jetruby)

Heroku: https://jetruby-iosadchiy.herokuapp.com/


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

Only one authentication provider is supported. Multiple providers might be supported with an authentication framework (e.g. devise).


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
