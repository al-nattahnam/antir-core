require 'singleton'

CONFIG_PATH = "/opt/core.yml"

module Antir
  class Core #< Antir::Resources::Core
    include Singleton
    include Cucub::LiveObject
    
    live :channel, :reply

    def initialize
      load_config
    end

    def load_config
      config = YAML.load_file(CONFIG_PATH)
      begin
        local = Antir::Resources::Core.first(:address => config['core']['host'])

        @engines_proxy = Cucub::LiveProxy.new
        @engines_proxy.channel = :request
        @engines_proxy.oid = 2
        @engines_proxy.balanced = :round_robin

        local_engines = local.engine_pools.engines
        if local_engines.size > 0
          @engines_proxy.connect(local_engines.collect { |engine| engine.address.to_s  })
        end

        # @worker_ports = config['core']['worker_ports']
        @address = config['core']['host']
      rescue
        throw "Core could not be initialized! Config is missing"
      end
    end

    def vps_create
      @engines_proxy.call('vps_create', {:code => 111})
    end

    def engine_register(address)
      #@engines_proxy.engaged
      @engines_proxy.connect(address)
    end

    def refresh
    end

    def start!
      Cucub.start!(@address)
    end
  end
end
