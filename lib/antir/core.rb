module Antir
  class Core
    include DataMapper::Resource
    storage_names[:default] = 'cores'

    property :id, Serial
    property :address, URI

    has n, :engine_pools
    has n, :engines, :through => :engine_pools
  end
end

require 'antir/core/engine_pool'
require 'antir/core/engine'
require 'antir/core/vps'
