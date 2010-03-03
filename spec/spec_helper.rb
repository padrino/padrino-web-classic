PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.dirname(__FILE__) + "/../config/boot"

MongoMapper.connection.drop_database(MongoMapper.database.name)

Spec::Runner.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  # Sinatra < 1.0 always disable sessions for test env
  # so if you need them it's necessary force the use 
  # of Rack::Session::Cookie
  PadrinoWeb.tap { |app| app.use Rack::Session::Cookie }
  # You can hanlde all padrino applications using instead:
  #   Padrino.application
end
