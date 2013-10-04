require 'logger'

# Author:: Elon Flegenheimer
# Copyright:: Copyright (c) 2013 Elon Flegenheimer
# License:: The MIT License (MIT)
# 
# A singleton logger accessible from ALL objects. It is intended to be used to:
# * send logger data to stdout OR
# * log to a file while consuming stdout & stderr data as log input OR
# * destroy stdout, stderr, & log data OR
# * do one of the above until transitioned to another of the above
#
# The logger can be altered just like a normal Logger:
#   logger.level = Logger::WARN
#
# Example usage:
#
#   TransitionalLogger.stdout
#   logger.info 'this message goes through the logger to stdout'
#   puts 'this works like usual'
#
#   TransitionalLogger.file('/tmp/whatever.log')
#   Object.new.logger.info 'this message goes through the logger to the file above'
#   puts 'this message also goes through the logger above'
#
#   TransitionalLogger.blackhole
#   Object.new.logger.error 'this message disappears'
#   puts 'this message disappears too!'
#
module TransitionalLogger

  VERSION = '1.0.0'

  class << self

    # Creates a logger that is accessible from all objects. The logger points
    # to stdout. Stdout is otherwise unaffected.
    def stdout
      reset if @streams
      @master_logger = infect_object(Logger.new($stdout))
    end

    # Creates the specified logger that is accessible from all objects. stdout
    # and stderr are redirected to this logger.
    #
    # Parameters match Logger#new.
    def file(*args)
      raise ArgumentError, 'Logger#new params must be specified for #file' if args.size == 0
      reset if @streams
      @master_logger = infect_object(Logger.new(*args))

      @streams = [$stdout, $stderr, $stdin]
      $stdout = CommandeeredOut.new(@master_logger)
      $stderr = CommandeeredErr.new(@master_logger)
      @master_logger
    end

    # Creates a logger that consumes stdout, stderr, and all logger messages.
    def blackhole
      file('/dev/null')
    end

    # Reset the changes that this object has introduced
    def reset
      @master_logger = nil
      Object.send :remove_method, :logger rescue nil
      if @streams
        $stdout, $stderr = @streams[0..1]
        @streams = nil
      end
    end

    # Logger accessor - otherwise accessible from any object
    def logger
      @master_logger
    end

    private

    # Define the logger method to return this in all objects
    def infect_object(logger)
      Object.send :define_method, :logger, ->{logger}
      logger
    end

  end

end

class CommandeeredIO < IO
  def initialize(logger)
    @logger = logger
  end
end

class CommandeeredOut < CommandeeredIO
  def write(s)
    @logger.info(s)
  end
end

class CommandeeredErr < CommandeeredIO
  def write(s)
    @logger.error(s)
  end
end
