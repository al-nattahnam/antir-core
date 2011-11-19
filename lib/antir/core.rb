module Antir
  class Core < Antir::Resources::Core

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

          puts @dispatcher.inspect
          puts @worker_pool.inspect

          @worker_pool.workers.each do |worker|
            puts worker.inspect
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
  end
end

require 'antir/core/dispatcher'
require 'antir/core/worker'
