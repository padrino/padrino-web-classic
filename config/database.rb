MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)

case Padrino.env
  when :development then MongoMapper.database = 'padrino_www_development'
  when :production  then MongoMapper.database = 'padrino_www'
  when :test        then MongoMapper.database = 'padrino_www_test'
end