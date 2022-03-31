source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.3'
gem 'puma', '~> 4.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'haml'
gem 'simple_form'
gem 'devise'
gem 'paperclip'
gem 'aws-sdk'
gem 'acts_as_votable'
gem 'coffee-script-source', '1.12.2'
gem 'bootstrap', '4.3.1'
gem 'jquery-rails'
gem 'pg'
gem 'pg_search'
gem 'cancancan'
gem 'summernote-rails'
gem 'will_paginate'
gem 'will_paginate-bootstrap4'
gem 'rails_refactor'
gem 'meta-tags'
gem 'serviceworker-rails'
gem 'fog-aws'
gem 'sitemap_generator'
gem 'select2-rails'
gem 'omniauth', '~> 1.9.1'
gem 'omniauth-google-oauth2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
