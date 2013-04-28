require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'warehouse_supervisor/template_binding'

include WarehouseSupervisor

describe TemplateBinding do

  it "should define methods" do
    t = TemplateBinding.new("tal", "cosa" => "otra")
    t.cosa.should eql "otra"
  end

  it "should not redefine template" do
    t = TemplateBinding.new("tal", "cosa" => "otra", "template" => "tala")
    expect {t.template}.to raise_error
  end

  it "should not break on non-existing methods" do
    t = TemplateBinding.new("tal", "cosa" => "otra", "template" => "tala")
    t.otrassss.should be_nil
  end

end
