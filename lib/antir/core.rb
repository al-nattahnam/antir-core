#require 'singleton'

module Antir
  class Core < Antir::Resources::Core
    #attr_reader :address
    #include Singleton

    @@local = Antir::Resources::Core.first
    def @@local.load_config(config_path)
      config = YAML.load_file(config_path)
      begin
        @address = config['core']['host']
        # @region = Antir::Resource::EnginePool.find_by_region(config['core']['region'])
        @worker_ports = config['core']['worker_ports']
      rescue
        throw "Core could not be initialized! Config is missing"
      end
    end

    def @@local.start
      @dispatcher = Antir::Core::Dispatcher.instance
      @worker_pool = Antir::Core::WorkerPool.new(@worker_ports)

      @worker_pool.workers.each do |worker|
        worker.start
      end
      @dispatcher.start
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
