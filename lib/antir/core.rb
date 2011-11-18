require 'singleton'

module Antir
  class Core
    include Singleton

    def start
      @dispatcher = Antir::Core::Dispatcher.instance
      @dispatcher.start
    end
  end
end

require 'antir/core/dispatcher'
