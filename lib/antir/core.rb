require 'singleton'

module Antir
  class Core
    attr_reader :address
    include Singleton

    def initialize
      @address = "127.0.0.1" # '10.40.1.107'
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
