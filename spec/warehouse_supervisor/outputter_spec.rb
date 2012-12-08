require 'warehouse_supervisor'

describe WarehouseSupervisor::Outputter do

  describe "#output_program" do

    let(:o) {WarehouseSupervisor::Outputter.new(nil)}

    it "should get the command for a program" do
      prog = {:command => "ls"}
      o.output_program("ls", prog).lines.to_a[0].strip.should eql "[program:ls]"
    end

    it "should output the opts" do
      prog = {:command => "ls"}
      o.output_program("ls", prog).lines.to_a[1].strip.should eql "command = ls"
    end

    it "should separate with a new line" do
      prog = {:command => "ls"}
      o.output_program("ls", prog)[-1, 1].should eql "\n"
    end

    it "should output hashes as env lists" do
      prog = {:environment => {:HOME => "tal", :USER => "cual"}}
      o.output_program("ls", prog).lines.to_a[1].strip.should =~ /environment = .*HOME="tal"/
      o.output_program("ls", prog).lines.to_a[1].strip.should =~ /environment = .*USER="cual"/
    end

    it "should output all the options" do
      prog = {
        :environment => {:HOME => "tal", :USER => "cual"},
        :command => "ls -l" 
      }
      o.output_program("ls", prog).should =~ /command = ls -l/
      o.output_program("ls", prog).should =~ /environment = .*HOME/
    end
  end

end
