#!/usr/bin/env sh

sudo gem install bundler
sudo bundle install
sudo pod setup
sudo bundle exec rake pod:install
sudo bundle exec rake clean &&
sudo bundle exec rake spec