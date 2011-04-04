PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.dirname(__FILE__) + "/../config/boot"

MongoMapper.connection.drop_database(MongoMapper.database.name)

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

Admin.set :delivery_method, :test

Admin.setup_application!
PadrinoWeb.setup_application!
