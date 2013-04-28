require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'thor'
require 'warehouse_supervisor/renderer'

module WarehouseSupervisor
  class WarehouseSupervisorCli < Thor
    class_option :group, :aliases => :g, :default => "development"
    class_option :config, :aliases => :c, :required => true

    desc "print erb_file", "output the file"
    def print(erb_file)
      puts generate_contents(options[:group] || "development", options[:config], erb_file)
    end

    private 

    def generate_contents(group, definitions_file, erb_file)
      definitions = YAML.load(File.read(definitions_file))[group.to_s]
      erb_content = File.read(erb_file)
      Renderer.new(definitions, erb_content).render
    end

  end
end
