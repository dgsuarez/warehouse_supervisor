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

  describe "#output_with_options" do
    it "should output each program with the given options" do
      options = {:user => "tal", :process_name => "%(program_name)_%(process_number)"}
      programs = {:ls => {:command => "ls"}}
      o = WarehouseSupervisor::Outputter.new(nil)
      o.output_with_options(programs, options).should =~ /user = tal/
      o.output_with_options(programs, options).should =~ /process_name = /
      o.output_with_options(programs, options).should =~ /command = ls/
    end

    it "should make the program the preferred source of options" do
      options = {:user => "tal", :process_name => "%(program_name)_%(process_number)"}
      programs = {:ls => {:command => "ls", :user => "cual"}}
      o = WarehouseSupervisor::Outputter.new(nil)
      o.output_with_options(programs, options).should =~ /user = cual/
    end

    it "should all the programs" do
      options = {:user => "tal"}
      programs = {:ls => {:command => "ls"}, :cat => {:command => "cat"}}
      o = WarehouseSupervisor::Outputter.new(nil)
      out = o.output_with_options(programs, options)
      out.lines.select {|x| x =~ /user = tal/}.should have(2).elements
    end

    it "should not break if no options are given" do
      programs = {:ls => {:command => "ls"}, :cat => {:command => "cat"}}
      o = WarehouseSupervisor::Outputter.new(nil)
      out = o.output_with_options(programs, nil)
      out.lines.select {|x| x =~ /command = /}.should have(2).elements
    end

  end

  describe "#output" do
    it "should output the programs with the options if no group is defined" do
      m = WarehouseSupervisor::Model.new
      m.options = {:opts => {:user => "tal"}}
      m.programs = {:ls => {:command => "ls"}, :cat => {:command => "cat"}}
      o = WarehouseSupervisor::Outputter.new(m)
      out = o.output
      out.should =~ /program:ls/
      out.should =~ /program:cat/
      out.should =~ /user = tal/
    end

    it "should break if no group is specified and there are more than 1 options group" do
      m = WarehouseSupervisor::Model.new
      m.options = {:opts => {:user => "tal"}, :other_opts => {:user => "cual"}}
      m.programs = {:ls => {:command => "ls"}, :cat => {:command => "cat"}}
      o = WarehouseSupervisor::Outputter.new(m)
      expect {o.output}.to raise_error
    end

  end

end
