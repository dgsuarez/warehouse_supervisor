require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'tempfile'
require 'fileutils'
require 'thor'
require 'warehouse_supervisor/renderer'

module WarehouseSupervisor
  class WarehouseSupervisorCli < Thor
    class_option :group, :aliases => :g, :default => "development"
    class_option :config, :aliases => :c, :required => true

    desc "print file", "output the file acording to the config"
    def print(erb_file)
      puts generate_contents(options[:group], options[:config], erb_file)
    end

    desc "start file", "start an undemonized supervisor with file"
    option :log_dir, :aliases => :q, :default => "log"
    def start(erb_file)
      Tempfile.open("supervisord.conf") do |f|
        log_dir = options[:log_dir]
        f.puts "[supervisord]"
        f.puts "logfile = #{File.join(log_dir, "supervisord.log")}"
        f.puts "childlogdir = #{log_dir}"
        f.puts "nodaemon = true"
        f.puts
        f.write generate_contents(options[:group], options[:config], erb_file)
        f.flush
        FileUtils.mkdir_p options[:log_dir]
        command = "supervisord -c '#{f.path}' -n"
        puts command
        exec command
      end
    end

    private 

    def generate_contents(group, definitions_file, erb_file)
      definitions = YAML.load(File.read(definitions_file))[group.to_s]
      erb_content = File.read(erb_file)
      Renderer.new(definitions, erb_content).render
    end

  end
end
