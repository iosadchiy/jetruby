# Appointments management system

[![Build Status](https://travis-ci.org/iosadchiy/jetruby.svg?branch=master)](https://travis-ci.org/iosadchiy/jetruby)
[![Codecov](https://img.shields.io/codecov/c/github/iosadchiy/jetruby.svg)](https://codecov.io/gh/iosadchiy/jetruby)


Heroku: https://jetruby-iosadchiy.herokuapp.com/


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
