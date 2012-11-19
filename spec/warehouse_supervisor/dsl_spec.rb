require 'warehouse_supervisor'

describe WarehouseSupervisor::DSL do

  it "should understand option definitions " do
    parsed = WarehouseSupervisor::DSL.parse do
      define_options :my_options do |opts|
        opts.user = "me"
      end
    end
    parsed.options.should eql({
      :my_options => {:user => "me"} 
    })
  end

  it "should understand hash option definitions" do
    parsed = WarehouseSupervisor::DSL.parse do
      define_options :my_options, :user => "me"
    end
    parsed.options.should eql({
      :my_options => {:user => "me"} 
    })
  end

  it "should understand opts as a hash" do
    parsed = WarehouseSupervisor::DSL.parse do
      define_options :my_options do |opts|
        opts[:user] = "me"
      end
    end
    parsed.options.should eql({
      :my_options => {:user => "me"} 
    })
  end

  it "should understand program definitions" do
    parsed = WarehouseSupervisor::DSL.parse do
      define_program :prog1 do |prog|
        prog[:command] = "ls"
      end

      define_program :prog2, :command => "ls"

      define_program :prog3 do |prog|
        prog.command = "ls"
      end
    end
    res = {:command => "ls"}
    parsed.programs.should eql({
      :prog1 => res,
      :prog2 => res,
      :prog3 => res
    })

  end

end
