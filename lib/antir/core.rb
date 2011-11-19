#require 'singleton'

module Antir
  class Core < Antir::Resources::Core
    #attr_reader :address
    #include Singleton

    @@local = nil

    # Antir::Core.load_config('.yml')
    # Antir::Core.local.start

    def self.load_config(config_path)
      config = YAML.load_file(config_path)
      begin
        @@local = Antir::Resources::Core.first(:address => config['core']['host'])
        #@address = config['core']['host']
        # @region = Antir::Resource::EnginePool.find_by_region(config['core']['region'])
        def @@local.worker_ports=(worker_ports)
          @worker_ports = worker_ports
        end
        @@local.worker_ports = config['core']['worker_ports']

        def @@local.worker_ports
          @worker_ports
        end

        def @@local.start
          @dispatcher = Antir::Core::Dispatcher.instance
          @worker_pool = Antir::Core::WorkerPool.new(@worker_ports)

          @worker_pool.workers.each do |worker|
            worker.start
          end
          @dispatcher.start
        end

      rescue
        throw "Core could not be initialized! Config is missing"
      end
    end

    def self.local
      @@local
    end

    #def self.method_missing(name, *args)
    #  instance.send(name, *args)
    #end
  end
end

require 'antir/core/dispatcher'
require 'antir/core/worker'
