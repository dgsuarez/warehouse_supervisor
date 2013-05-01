require 'thor'
require 'warehouse_supervisor'

module WarehouseSupervisor
  class WarehouseSupervisorCli < Thor
    class_option :group, :aliases => :g, :default => "development"
    class_option :config, :aliases => :c, :required => true

    desc "print file", "output the file acording to the config"
    def print(erb_file)
      puts WarehouseSupervisor::Main.new(erb_file, options).generate_contents
    end

    desc "start file", "start an undemonized supervisor with file"
    option :log_dir, :aliases => :q, :default => "log"
    def start(erb_file)
      WarehouseSupervisor::Main.new(erb_file, options).start
    end

  end
end
