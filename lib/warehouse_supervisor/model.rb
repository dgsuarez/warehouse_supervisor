module WarehouseSupervisor
  class Model
    attr_accessor :options, :programs

    def initialize
      @options = {}
      @programs = {}
    end
  end
end
