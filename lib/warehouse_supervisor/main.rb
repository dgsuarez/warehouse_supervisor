require 'yaml'
require 'tempfile'
require 'warehouse_supervisor/renderer'

module WarehouseSupervisor
  class Main
    def initialize(erb_file, options={})
      @erb_file = erb_file
      @options = options
    end

    def generate_contents
      unless File.exist?(@options[:config])
        STDERR.puts "Bad file '#{@options[:config]}'"
        exit 1
      end
      unless File.exist?(@erb_file)
        STDERR.puts "Bad file '#{@erb_file}'"
        exit 1
      end
      definitions = YAML.load(File.read(@options[:config]))[@options[:group].to_s]
      unless definitions
        STDERR.puts "Bad group '#{@options[:group]}'"
        exit 1
      end
      erb_content = File.read(@erb_file)
      Renderer.new(definitions, erb_content).render
    end

    def start
      Tempfile.open("supervisord.conf") do |f|
        Tempfile.open("supervisord.log") do |l|
          f.puts "[supervisord]"
          f.puts "nodaemon = true"
          f.puts "logfile = #{l.path}"
          f.puts "loglevel = debug"
          f.write self.generate_contents
          f.flush
          command = "supervisord -c '#{f.path}'"
          puts command
          exec command
        end
      end
    end
  end
end
