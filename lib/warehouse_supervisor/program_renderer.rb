require 'warehouse_supervisor/template_binding'
require 'erb'

module WarehouseSupervisor
  class ProgramRenderer

    def initialize(definitions, erb_content)
      @definitions = definitions
      @erb_content = erb_content
    end

    def render(program_name)
      program_definition = TemplateBinding.new(program_name, @definitions[program_name])
      ERB.new(@erb_content, nil, nil, "@output").result(program_definition.get_binding)
    end
  end

end
