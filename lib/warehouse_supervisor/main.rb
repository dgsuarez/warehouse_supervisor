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
        f.puts "[supervisord]"
        f.puts "logfile = #{File.join(log_dir, "supervisord.log")}"
        f.puts "childlogdir = #{log_dir}"
        f.puts "nodaemon = true"
        f.write self.generate_contents
        f.flush
        FileUtils.mkdir_p(log_dir)
        command = "supervisord -c '#{f.path}'"
        puts command
        exec command
      end
    end
  end
end
