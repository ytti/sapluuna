require_relative 'sapluuna'
begin
  require 'slop'
rescue LoadError
  warn "sudo gem install slop ## required by sapluuna CLI"
  exit 42
end



class Sapluuna
  class CLI
    ROOT = '.'
    attr_reader :debug

    def initialize
      @opts   = opts_parse
      args    = @opts.arguments
      @file   = args.shift
      @labels = @opts[:label].split(/[,\s]+/) if @opts[:label]
      @vars   = {}
      @disco  = @opts[:variables]
      args.each do |var|
        name, value = var.split '='
        @vars[name.to_sym] = value
      end
      if @opts.debug?
        @debug = true
        Log.level = Logger::DEBUG
      end
    end

    def run
      raise MissingOption, 'File is mandatory argument' unless @file
      sap = Sapluuna.new labels: @labels, variables: @vars,
                         discover_variables: @disco,
                         root_directory: (@opts[:root] or ROOT)
      cfg = sap.parse File.read(@file)
      puts @disco ? sap.discovered_variables : cfg
    rescue => error
      crash error
      raise
    end

    private

    def opts_parse
      Slop.parse do |o|
        o.banner = 'Usage: sapluuna [OPTIONS] FILE [variables]'
        o.bool   '-d', '--debug',     'turn on debugging'
        o.string '-l', '--label',     'commma separated list of labels'
        o.bool   '-v', '--variables', 'displays required variables'
        o.string '-r', '--root',      'root directory for template import'
        o.on     '-h', '--help' do puts o; exit; end
      end
    end

    def crash error
    end
  end
end
