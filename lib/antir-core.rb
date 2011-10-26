#require 'rubygems'
require 'dm-migrations'
require 'dm-core'
require 'dm-types'

#DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, 'postgres://postgres:postgres@localhost/antir')

require 'antir/core/engine'
require 'antir/core/engine_pool'
require 'antir/core'
require 'antir/core/vps'

#DataMapper.auto_migrate!
#DataMapper.auto_upgrade!
