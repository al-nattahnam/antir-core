require 'dm-migrations'
require 'dm-core'
require 'dm-types'

#DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, 'postgres://postgres:postgres@localhost/antir')

require 'antir/core.rb'

#DataMapper.auto_migrate!
#DataMapper.auto_upgrade!
