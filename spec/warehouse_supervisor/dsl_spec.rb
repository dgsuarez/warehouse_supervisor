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

end
