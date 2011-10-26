require 'antir/core/engine'
require 'antir/core/engine_pool'

module Antir
  class Core
    include DataMapper::Resource
    storage_names[:default] = 'cores'

    property :id, Serial
    property :address, URI

    has n, :engine_pools, :through => Resource
    has n, :engines, :through => :engine_pools
  end
end

require 'antir/core/vps'
