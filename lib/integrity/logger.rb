module Integrity
  # Extend the stdlib Logger with some options for Integrity. This is the logger
  # instantiated by default for <tt>Integrity.logger</tt>, using 
  # <tt>Integrity.config.log_file</tt>. If you want a different logger object,
  # just set it on the configuration.
  class Logger < ::Logger
    # Only log INFO or higher messages, rotate the log when it reaches 1MB, and
    # keep 7 old log files.
    def initialize(path, keep_old_logs=7, rotate_on_size=1024**2)
      super(path, keep_old_logs, rotate_on_size)
      self.level = INFO
      self.formatter = Formatter.new
    end

    class Formatter < ::Logger::Formatter #:nodoc:
      def call(severity, time, progname, msg)
        time.strftime("[%H:%M:%S] ") + msg2str(msg) + "\n"
      end
    end
  end
end
