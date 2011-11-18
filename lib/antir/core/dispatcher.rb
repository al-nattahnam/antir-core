require 'singleton'
require 'em-zeromq'
require 'json'

module Antir
  class Core
    class Dispatcher
      include Singleton

      def initialize
        @engines = nil
        @subscriber = nil
        @driver = nil
      end

      def start
        EM.run do
          ctx = EM::ZeroMQ::Context.new(1)
        
          c = Antir::Resources::Core.first
          engines = c.engine_pools.engines.collect{|e| e.address.to_s}
          engines.each do |address|
            @engines = ctx.connect(ZMQ::REQ, "tcp://#{address}:5555")
          end
        
          @driver = ctx.bind(ZMQ::PULL, "tcp://#{Antir::Core.address}:3340", DriverHandler.new)

          ctx.bind(ZMQ::PULL, "tcp://127.0.0.1:5556", InnerHandler.new)
        
          @engine_events = ctx.bind(ZMQ::PULL, "tcp://#{Antir::Core.address}:3341", EngineHandler.new)
        
          n = 0
        end
      end

      class DriverHandler
        def on_readable(socket, messages)
          messages.each do |m|
            # TODO revisar que llegan mensajes duplicados vacios
            msg = m.copy_out_string
            if not m.copy_out_string.empty?
              msg = JSON.parse(msg)
              puts msg.inspect
          
              # Puede recibir un mensaje de Refresh
              if msg['code'] == '00'
                c = Antir::Resources::Core.first
                engines = c.engine_pools.engines.collect{|e| e.address.to_s}
                ctx = ZMQ::Context.new
                @engines = ctx.socket ZMQ::REQ
                engines.each do |address|
                  @engines.connect "tcp://#{address}:5555"
                end
              end
          
              if msg['resource'] == 'vps' and @engines
              #if msg['code'] == '01' and @@engines
                if msg['action'] == 'create'
                  serialized = msg.to_json

                  ## Implementar una capa intermedia con Beanstalkd que se ocupe de enviar los mensajes al Engine,
                  ## esto bloquea la comunicacion Driver <-> Core
                  puts serialized
                  resp = Antir::Core::WorkerPool.push serialized
                  #@engines.send_string(serialized)
                  #puts @engines.recv_string
                  # TODO mover funcionalidad al worker ##

                end
              end
              socket.send_msg('ok!')
            end
          end
        end
      end

      class InnerHandler
        def on_readable(socket, messages)
          messages.each do |m|
            puts m.copy_out_string
          end
        end
      end

      class EngineHandler
        def on_readable(socket, messages)
          messages.each do |m|
            puts 'engine'
            #m.send_msg('ok')
          end
        end
      end
    end
  end
end
