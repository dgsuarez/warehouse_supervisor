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
        merged_opts = deep_merge(options || {}, opts)
        output_program(name, merged_opts)
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

    private

    def hash_to_csv(hash)
      hash.map{|k, v| "#{k}=\"#{v}\""}.join(",")
    end

    def deep_merge(h1, h2)
      h1.merge(h2) do |key, old_val, new_val|
        if old_val.kind_of?(Hash) && new_val.kind_of?(Hash)
          deep_merge(old_val, new_val) 
        else
          new_val
        end
      end
    end

  end
end
