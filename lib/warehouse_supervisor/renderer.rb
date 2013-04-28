require 'warehouse_supervisor/program_renderer'

module WarehouseSupervisor
  class Renderer
    def initialize(definitions, erb_content)
      @definitions = definitions
      @erb_content = erb_content
    end

    def render
      r = ProgramRenderer.new(@definitions, @erb_content)
      @definitions.keys.map { |program_name| r.render(program_name) }.join("\n")
    end

  end
end
