require 'warehouse_supervisor'

namespace :ws do

  def get_opts
    erb_file = ENV['TEMPLATES'] || raise("required TEMPLATES file")
    config_file = ENV['CONFIG']|| raise("required CONFIG file")
    group = ENV['WS_GROUP'] 
    [erb_file, {:group => group, :config => config_file}]
  end

  desc "output the file acording to the config"
  task :print do
    puts WarehouseSupervisor::Main.new(*get_opts()).generate_contents
  end

  desc "start an undemonized supervisor with file"
  task :start do
    puts WarehouseSupervisor::Main.new(*get_opts()).start
  end

end
