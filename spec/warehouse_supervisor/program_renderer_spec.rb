require 'yaml'
require 'warehouse_supervisor/program_renderer'

include WarehouseSupervisor

describe ProgramRenderer do

  let(:erb_content) {File.read "example/processes.conf.erb"}
  let(:definitions) {YAML.load(File.read "example/warehouse_supervisor.yml")}

  it "should render the title once" do
    pr = ProgramRenderer.new(definitions["development"], erb_content).render("resque_web")
    pr.scan(/\[program:resque_web\]/).should have(1).element
  end

  it "should not render other templates" do
    pr = ProgramRenderer.new(definitions["development"], erb_content).render("resque_web")
    pr.should_not =~ /worker/
  end

  it "should render the variables" do
    pr = ProgramRenderer.new(definitions["development"], erb_content).render("resque_web")
    pr.should =~ /directory = awesome/
  end

  it "should have a pretty output" do
    pr = ProgramRenderer.new(definitions["development"], erb_content).render("resque_web")
    pr.should_not include "\n\n"
  end

  it "should remove starting spaces" do
    pr = ProgramRenderer.new(definitions["development"], erb_content).render("resque_web")
    pr.should_not include "^\s+"
  end

  it "should not print stuff outside of the template" do
    erb_content =  %q{
      I should not appear (upper)

      <% template :tal do %>
        awambabaluba
      <% end %>

      I should not appear (downer)
    }
    pr = ProgramRenderer.new({"cual" => {"template" => "tal"}}, erb_content).render("cual").should_not =~ /appear/
  end
end
