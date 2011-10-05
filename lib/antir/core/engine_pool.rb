module Antir
  class Core
    class EnginePool
      include DataMapper::Resource
      storage_names[:default] = 'engine_pools'

      property :id, Serial
      has n, :engines
      has n, :cores#, :through => Resource
      
      #after :save do |engine_pool|
      # engine_pool.cores.each do |core|
        # core.push update on EnginePool (solo en Driver)
      # end
      #end
    end
  end
end
