source :gemcutter

# Project requirements
gem 'sinatra', '1.0.a' # be sure to load the --pre version!
gem 'rack-flash'
gem 'thin' # or mongrel
gem 'RedCloth'
gem 'coderay'

# Component requirements
gem 'haml'
gem 'mongo_mapper'
gem 'mongo_ext', :require => "mongo"

# Test requirements
gem 'rspec', :require => "spec", :group => "test"
gem 'rack-test', :require => 'rack/test', :group => 'test'

# Padrino
%w(core gen helpers mailer admin).each do |gem|
  gem 'padrino-' + gem, :path => '/src/padrino-framework/padrino-' + gem
end
