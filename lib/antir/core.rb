require 'singleton'

module Antir
  class Core #< Antir::Resources::Core
    include Singleton
    include Cucub::LiveObject

    @@local = nil

    # Antir::Core.load_config('.yml')
    # Antir::Core.local.start

    def self.load_config(config_path)
      config = YAML.load_file(config_path)
      begin
        @@local = Antir::Resources::Core.first(:address => config['core']['host'])

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

        def @@local.worker_pool
          @worker_pool
        end
      rescue
        throw "Core could not be initialized! Config is missing"
      end
    end

    def self.local
      @@local
    end
  end
end

require 'antir/core/dispatcher'
require 'antir/core/worker'
