require 'json'
#require 'zlib'
require 'beanstalk-client'

#require 'em-zeromq'

module Antir
  class Core
    class WorkerPool

      def initialize(worker_ports=[])
        @workers = []
        worker_ports.each do |port|
          @workers << Antir::Engine::Worker.new('127.0.0.1', port)
        end

        @beanstalk = Beanstalk::Pool.new(worker_ports.collect{|port| "127.0.0.1:#{port}" })
      end

      def workers
        @workers
      end

      def push(msg)
        #Zlib::Inflate.inflate(msg)
        deserialized_msg = JSON.parse(msg)
        @beanstalk.yput(deserialized_msg)
        {:id => 1, :status => 'got'} # core asignaria un id de tarea
      end
    end

    class Worker
      def initialize(address, port)
        @beanstalk = Beanstalk::Pool.new(["#{address}:#{port}"])
        
        context = ZMQ::Context.new
        @report = context.socket ZMQ::PUSH
        @report.connect("ipc://127.0.0.1:5556")
      end

      # service
      # create  | xml
      # destroy | id
      # stop    | id

      def start
        process = fork {
          loop do
            if self.queue_size > 0 then
              job = @beanstalk.reserve
              # job.state -> reserved

              #self.send(job.ybody['action'], job.ybody)
              puts "processed: #{job.id} - #{job.ybody}"
              @report.send_string('ok')

              # transaction begin
              #if not job.ybody == nil
              #  self.send(job.ybody['action'], job.ybody)
              #  job.touch # para avisar al queue que todavia se esta procesando
              #end
            
              # job.touch # para avisar al queue que todavia se esta procesando
              # job.time_left
              # job.timeouts
              # job.release # para devolver al queue
              
              job.delete # cuando se termino Ok el proceso, lo saca del queue
              # job.state
              
              #job.bury # cuando se termino Con errores el proceso, lo saca del queue
              # job.state -> buried
            
              # transaction end
            end
          end
        }
      end

      #def create(options)
      #  puts "#{@beanstalk.last_conn.addr}: create #{options['code']}\n"
      #  vps = Antir::Engine::VPS.new

      #  code = options['code']
      #  vps.id = code
      #  vps.name = code
      #  vps.ip = "10.10.1.#{code}"
      #  vps.create

      #  @report.send_string("created #{options['code']}")
      #  #msg = @@report.recv()
      #end

      #def destroy(options)

      def queue_size
        @beanstalk.stats["current-jobs-ready"]
      end

      def total_jobs
        @beanstalk.stats["total-jobs"] # Cantidad total de jobs resueltos/no resueltos
      end
    end
  end
end
