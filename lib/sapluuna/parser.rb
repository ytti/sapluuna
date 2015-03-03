require 'strscan'

class Sapluuna
  class Parser
    CODE_OPEN      = '<%\s*'
    CODE_CLOSE     = '\s*%>'
    TEMPLATE_OPEN  = '^\s*{{{\s*'
    TEMPLATE_CLOSE = '\s*}}}\s*$'
    NEW_LINE       = "\n"
    class ParserError < Error; end
    class UnterminatedBlock < ParserError; end

    def initialize
      @sc    = StringScanner.new ''
    end

    def parse input
      level      = 0
      cfg        = []
      @sc.string = input
      loop do
        if @sc.scan_until Regexp.new(TEMPLATE_OPEN)
          cfg << [:template, get_labels, get_template(level)]
        else
          break
        end
      end
      @sc.string = '' # no need to keep it in memory
      cfg
    end

    private

    def get_labels
      if @sc.matched[-1] != NEW_LINE
        labels = @sc.scan_until Regexp.new(NEW_LINE)
        labels.strip.split(/\s+/)
      else
        []
      end
    end

    def re_combine *args
      re = args.map do |arg|
        '(?:%s)' % arg
      end.join('|')
      Regexp.new re
    end

    def clean_scan scan
      endstr = -(@sc.matched.size+1)
      scan[0..endstr]
    end

    def get_template level
      cfg = []
      loop do
        scan = @sc.scan_until re_combine(CODE_OPEN, TEMPLATE_OPEN, TEMPLATE_CLOSE)
        raise UnterminatedBlock, "template at #{level}, #{@sc.pos} runs forever" unless scan
        cfg << [:cfg, clean_scan(scan)]
        case @sc.matched

        when Regexp.new(CODE_OPEN)
          scan = @sc.scan_until Regexp.new(CODE_CLOSE)
          raise UnterminatedBlock, "code at #{level}, #{@sc.pos} runs forever" unless scan
          cfg << [:code, clean_scan(scan)]

        when Regexp.new(TEMPLATE_OPEN)
          cfg << [:template, get_labels, get_template(level+1)]

        when Regexp.new(TEMPLATE_CLOSE)
          return cfg
        end
      end
    end

  end
end
