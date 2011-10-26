#require 'rubygems'
require 'dm-migrations'
require 'dm-core'
require 'dm-types'

#DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, 'postgres://postgres:postgres@localhost/antir')

require 'antir/engine'
require 'antir/engine_pool'
require 'antir/core'
require 'antir/vps'

#DataMapper.auto_migrate!
#DataMapper.auto_upgrade!
