rake db:create RAILS_ENV=development
rake db:migrate RAILS_ENV=development
rake db:create RAILS_ENV=test
rake db:test:load
rake test
