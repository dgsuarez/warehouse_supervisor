require 'warehouse_supervisor'

describe WarehouseSupervisor::DSL do

  it "should understand option definitions " do
    parsed = WarehouseSupervisor::DSL.parse <<-EOF
      define_options :my_options do |opts|
        opts.user = "me"
      end
    EOF
    parsed.options.should eql({
      :my_options => {:user => "me"} 
    })
  end

  it "should understand hash option definitions" do
    parsed = WarehouseSupervisor::DSL.parse <<-EOF
      define_options :my_options, :user => "me"
    EOF
    parsed.options.should eql({
      :my_options => {:user => "me"} 
    })
  end

  it "should understand opts as a hash" do
    parsed = WarehouseSupervisor::DSL.parse <<-EOF
      define_options :my_options do |opts|
        opts[:user] = "me"
      end
    EOF
    parsed.options.should eql({
      :my_options => {:user => "me"} 
    })
  end

  it "should understand program definitions" do
    parsed = WarehouseSupervisor::DSL.parse <<-EOF
      define_program :prog1 do |prog|
        prog[:command] = "ls"
      end

      define_program :prog2, :command => "ls"

      define_program :prog3 do |prog|
        prog.command = "ls"
      end
    EOF
    res = {:command => "ls"}
    parsed.programs.should eql({
      :prog1 => res,
      :prog2 => res,
      :prog3 => res
    })

  end

end
