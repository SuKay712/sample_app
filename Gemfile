source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}
ruby "3.2.2"
gem "config"

gem "rails", "~> 7.0.5"

gem "sprockets-rails"

gem "mysql2", "~> 0.5"

gem "jbuilder"

gem "puma", "~> 5.0"

gem "importmap-rails"

gem "turbo-rails"

gem "stimulus-rails"

gem "bcrypt", "3.1.18"

gem "sassc-rails"

gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)

gem "bootstrap"

gem "bootsnap", require: false

gem "mini_racer", platforms: :ruby

# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i(mri mingw x64_mingw)
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
  gem "pry-rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
