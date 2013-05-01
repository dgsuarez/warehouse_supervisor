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
      definitions = YAML.load(File.read(@options[:config]))[@options[:group].to_s]
      erb_content = File.read(@erb_file)
      Renderer.new(definitions, erb_content).render
    end

    def start
      Tempfile.open("supervisord.conf") do |f|
        Tempfile.open("supervisord.log") do |l|
          f.puts "[supervisord]"
          f.puts "nodaemon = true"
          f.puts "logfile = #{l.path}"
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
