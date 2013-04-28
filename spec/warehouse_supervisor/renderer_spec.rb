require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'warehouse_supervisor/renderer'

include WarehouseSupervisor

describe Renderer do
  let(:erb_content) {File.read "example/processes.conf.erb"}
  let(:definitions) {YAML.load(File.read "example/warehouse_supervisor.yml")}

  it "should render the full file" do
    c = Renderer.new(definitions["development"], erb_content).render
    c.scan(/\[program:resque_web\]/).should have(1).element
    c.scan(/\[program:resque_workers\]/).should have(1).element
    c.scan(/\[program:resque_scheduler\]/).should have(1).element
  end


end
