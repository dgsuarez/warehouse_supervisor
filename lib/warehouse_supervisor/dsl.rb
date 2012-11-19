module WarehouseSupervisor
  class DSL

    attr_reader :options

    def self.parse(&block)
      instance = self.new
      instance.instance_eval(&block)
      instance
    end

    def initialize
      @options = {}
    end

    def define_options(name, *args, &block)
      @options[name] = {}
      if args[0] && args[0].kind_of?(Hash)
        @options[name].merge!(args[0])
      end
      if block_given?
        bp = BlockParser.new(block)
        @options[name].merge!(bp.get_result)
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
