module WarehouseSupervisor
  class Outputter

    def initialize(model)
      @model = model
    end

    def output_program(name, prog)
      out = []
      out << "[program:#{name}]"
      prog.each do |name, val|
        res = "#{name} = "
        if val.kind_of? Hash
          r = []
          val.each do |opt_name, opt_value|
            r << "#{opt_name}=\"#{opt_value}\""
          end
          res << r.join(",")
        else
          res << val
        end
        out << res
      end
      out.join("\n") + "\n"
    end
    
  end
end
