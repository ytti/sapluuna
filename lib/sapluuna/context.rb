class Sapluuna
  class Context
    attr_reader :discovered_variables

    RootDirectory = '.'

    class VariableMissing < Error; end

    def initialize opts
      @opts                 = opts.dup
      @discover_variables   = opts.delete :discover_variables
      @variables            = (opts.delete(:variables) or {})
      @root_directory       = (opts.delete(:root_directory) or RootDirectory)
      @output               = ''
      @discovered_variables = []
    end

    def text value
      @output << value
    end

    def code value
      @output << eval(value).to_s
    end

    def str
      @output
    end

    def is value
      [:define, value]
    end

    private

    def import file
      template = File.read resolve_file(file)
      sapl     = Sapluuna.new @opts.dup
      output   = sapl.parse template
      @discovered_variables += sapl.discovered_variables
      output
    end

    def resolve_file file
      # should we avoid ../../../etc/passwd style input here?
      # why? we control templates?
      File.join @root_directory, file
    end

    def method_missing method, *args
      if Array === args.first and args.first.first == :define
        @variables[method] = args.first.last
        ""
      elsif @variables[method]
        @variables[method]
      else
        if @discover_variables
          @discovered_variables << method
          ""
        else
          raise VariableMissing, "variable '#{method}' required, but not given"
        end
      end
    end
  end
end
