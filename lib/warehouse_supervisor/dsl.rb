module WarehouseSupervisor
  class DSL

    attr_reader :options, :programs

    def self.parse(&block)
      instance = self.new
      instance.instance_eval(&block)
      instance
    end

    def initialize
      @options = {}
      @programs = {}
    end


    def define_program(name, *args, &block)
      define_for(@programs, name, *args, &block)
    end

    def define_options(name, *args, &block)
      define_for(@options, name, *args, &block)
    end

    def define_for(hash,name,*args,&block)
      hash[name] = {}
      if args[0] && args[0].kind_of?(Hash)
        hash[name].merge!(args[0])
      end
      if block_given?
        bp = BlockParser.new(block)
        hash[name].merge!(bp.get_result)
      end
    end

  end

  class BlockParser
    def initialize(block)
      @block = block
      @result = {}
    end

    def get_result
      self.instance_eval &@block  
      @result
    end

    def []=(key, value)
      @result[key.to_sym] = value
    end

    def method_missing(name, *args, &block)
      name_s = name.to_s
      if name_s =~ /=$/
        @result[name_s.gsub("=", "").to_sym] = args[0]
      else
        super
      end
    end

  end

end
