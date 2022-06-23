# README

## System dependencies
 * Ruby 3.0.1 + mysql 8\

## Set up
 * To use rbenv and Homebrew, skip to "Set up with rbenv and Homebrew" section

## Set up with rbenv and Homebrew
### prepare middleware
 * install Homebrew https://brew.sh/index_ja
 * `brew install rbenv`
 * `brew install ruby-build`
 * `brew install mysql@8.0`
 * `echo 'export PATH="/usr/local/opt/mysql@8.0/bin:$PATH"' >> ~/.bash_profile`
 * `source ~/.bash_profile`

### install libraries
 * `bundle install --path vendor/bundle`

## System dependencies
 * yarn 1.22.x

## Setup & Start
 * `brew install yarn`
 * `yarn add jquery` (if needed)
 * `yarn add bootstrap@next @popperjs/core ` (if needed)
### Setup database
 * `mysql.server start`
 * `bundle exec rails db:create`
 * `bundle exec rails db:migrate`

### run server
 * `bundle exec rails s`
 * `0.0.0.0:3000`
