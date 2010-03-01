source :gemcutter

# Project requirements
gem 'sinatra', '1.0.a' # be sure to load the --pre version, so we can test it.
gem 'rack-flash'
gem 'thin' # or mongrel
gem 'RedCloth'
gem 'popen4'

# Component requirements
gem 'haml'
gem 'mongo_mapper'
gem 'mongo_ext', :require => "mongo"

# Test requirements
gem 'rspec', :require => "spec", :group => "test"
gem 'rack-test', :require => 'rack/test', :group => 'test'

# Padrino
%w(core gen helpers mailer admin).each do |gem|
  gem 'padrino-' + gem, :path => '/src/padrino-framework/padrino-' + gem , :group => 'development'
end

gem 'padrino', '0.9.3', :group => 'production'
