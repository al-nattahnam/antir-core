require 'singleton'

module Antir
  class Core
    attr_reader :address
    include Singleton

    def load_config(config_path)
      config = YAML.load_file(config_path)
      begin
        @address = config['core']['host']
        # @region = Antir::Resource::EnginePool.find_by_region(config['core']['region'])
        @worker_ports = config['core']['worker_ports']
      rescue
        throw "Core could not be initialized! Config is missing"
      end
    end

    def start
      @dispatcher = Antir::Core::Dispatcher.instance
      @dispatcher.start
    end

    def self.method_missing(name, *args)
      instance.send(name, *args)
    end
  end
end

require 'antir/core/dispatcher'
require 'antir/core/worker'
