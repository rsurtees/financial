require 'rubygems'
#require 'mysql_api'
#require 'mysql'
require 'active_record'
require 'active_record/railtie'
require 'logger'


@log = Logger.new('ActiveRecord.log')
@log.level = level = Logger::DEBUG
@log.datetime_format = "%Y-%m-%d %H:%M:%S"


#ActiveRecord::Base.establish_connection(
#        :adapter => "mysql",
#        :database => "financial2010",
#        :username => "root",
#        :host => "localhost"
#)

ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => "../NBCdata_file.sql3"
)


create_all
