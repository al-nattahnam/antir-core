module Antir
  class Core
    class Engine
      include DataMapper::Resource
      storage_names[:default] = 'engines'

      property :id, Serial
      property :address, URI
    
      belongs_to :engine_pool

      # state machine: online / offline, destroy
    end
  end
end
