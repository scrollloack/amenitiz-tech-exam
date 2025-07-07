#!/usr/bin/env bash

set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

bundle exec rails db:prepare
bundle exec rails db:migrate
bundle exec rails db:seed