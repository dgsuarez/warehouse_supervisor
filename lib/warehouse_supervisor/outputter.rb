module WarehouseSupervisor
  class Outputter

    def initialize(model)
      @model = model
    end
    
    def output_with_options(programs, options)
       programs.map {|name, opts| output_program(name, options.merge(opts))}.join
    end

    def output_program(prog_name, opts)
      opt_list = opts.map do |name, val|
        res = "#{name} = "
        if val.kind_of? Hash
          res + hash_to_csv(val)
        else
          res + val
        end
      end
      ["[program:#{prog_name}]"].concat(opt_list).join("\n") + "\n"
    end

    def hash_to_csv(hash)
      hash.map{|k, v| "#{k}=\"#{v}\""}.join(",")
    end
  end
end
