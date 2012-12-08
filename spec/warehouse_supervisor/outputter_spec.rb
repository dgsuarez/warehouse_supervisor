require 'warehouse_supervisor'

describe WarehouseSupervisor::Outputter do

  it "should get the command for a program" do
    prog = {:ls => {:command => "ls"}}
    o = WarehouseSupervisor::Outputter.new(nil)
    o.output_program(prog).lines.to_a[0].strip.should eql "[program:ls]"
  end

  it "should output the opts" do
    prog = {:ls => {:command => "ls"}}
    o = WarehouseSupervisor::Outputter.new(nil)
    o.output_program(prog).lines.to_a[1].strip.should eql "command = ls"
  end
  
  it "should separate with a new line" do
    prog = {:ls => {:command => "ls"}}
    o = WarehouseSupervisor::Outputter.new(nil)
    o.output_program(prog)[-1, 1].should eql "\n"
  end

  it "should output hashes as env lists" do
    prog = {:ls => {:environment => {:HOME => "tal", :USER => "cual"}}}
    o = WarehouseSupervisor::Outputter.new(nil)
    o.output_program(prog).lines.to_a[1].strip.should =~ /environment = .*HOME="tal"/
    o.output_program(prog).lines.to_a[1].strip.should =~ /environment = .*USER="cual"/
  end

  it "should output all the options" do
    prog = {:ls => {
      :environment => {:HOME => "tal", :USER => "cual"},
      :command => "ls -l" 
    }}
    o = WarehouseSupervisor::Outputter.new(nil)
    o.output_program(prog).should =~ /command = ls -l/
    o.output_program(prog).should =~ /environment = .*HOME/
  end
end
