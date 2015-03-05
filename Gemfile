source 'http://rubygems.org'

ruby '1.9.3'
gem 'rails', '2.3.18'

gem 'thin'
gem 'haml'
gem 'haml-rails'

gem 'whois', "1.3.0"
gem 'rdoc'

group :development, :test do
  gem 'rspec', '1.3.1'
  gem 'rspec-rails', '1.3.4'
  gem 'autotest'
  gem 'sqlite3-ruby', '1.3.1', :require => 'sqlite3'
end

group :test do
  gem 'cucumber', '>= 0.2.2'
  gem 'flexmock'
  gem 'factory_girl'
  gem 'database_cleaner', '>=0.5.0'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end



# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
