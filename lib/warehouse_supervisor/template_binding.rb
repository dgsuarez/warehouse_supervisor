module WarehouseSupervisor

  class TemplateBinding 
    def initialize(program_name, hash)
      @program_name = program_name
      @template = hash["template"]
      singleton = class << self; self end
      hash.each do |method_name, value|
        singleton.send(:define_method, method_name) {value} unless method_name == "template"
      end
    end

    def template(t)
      if @template == t.to_s
        @output << "[program:#{@program_name}]"
        yield
      end
    end

    def method_missing(*args)
      nil
    end

    def get_binding
      binding
    end

  end
end
