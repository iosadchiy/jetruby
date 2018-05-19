release: bin/rails db:migrate
web: bin/rails server
worker: bundle exec sidekiq -q default -q mailers -t 25 -c 10
