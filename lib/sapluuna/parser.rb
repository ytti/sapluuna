class Sapluuna

  CODE_OPEN      = '<%'
  CODE_CLOSE     = '%>'
  TEMPLATE_OPEN  = '{{{'
  TEMPLATE_CLOSE = '}}}'

  class Parser < Parslet::Parser
    rule(:space)       { match(' ').repeat(1) }
    rule(:space?)      { space.maybe }
    rule(:newline)     { match('\n') }
    rule(:newline?)    { newline.maybe }
    rule(:whitespace)  { (space|newline).repeat(1) }
    rule(:whitespace?) { whitespace.maybe }

    rule(:template_open)  { space? >> str(TEMPLATE_OPEN) >> space? >> labels.as(:labels).maybe >> newline }
    rule(:template_close) { space? >> str(TEMPLATE_CLOSE)>> space? >> newline }
    rule(:code_open)      { str(CODE_OPEN) >> space? }
    rule(:code_close)     { space? >> str(CODE_CLOSE) }
    rule(:text_close)     { (template_open|template_close|code_open) }
    rule(:labels)         { (newline.absent? >> any).repeat(1) }

    rule(:text)  { ( text_close.absent? >> any).repeat(1).as(:text) }
    rule(:code)  {
      code_open >>
      (code_close.absent? >> any).repeat.as(:code) >>
      code_close
    }

    rule(:template) {
      (template_open >>
      (template|code|text).repeat >>
      template_close).repeat(1).as(:template)
    }
    
    rule(:file) { (template|text).repeat }
    root :file
  end
end
