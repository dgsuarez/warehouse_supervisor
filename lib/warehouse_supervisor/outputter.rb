module WarehouseSupervisor
  class Outputter

    def initialize(model)
      @model = model
    end

    def output
      if @model.options.length > 1
        raise RuntimeError.new("More than 1 set of options")
      end
      output_with_options(@model.programs, @model.options.values.first)
    end
    
    def output_with_options(programs, options)
      o = programs.map do |name, opts|
        output_program(name, (options || {}).merge(opts))
      end
       o.join
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
