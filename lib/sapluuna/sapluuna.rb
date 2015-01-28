require 'parslet'

class Sapluuna

  class Error < StandardError; end
  class InvalidOption < StandardError; end
  class MissingOption < StandardError; end
  class InvalidType < Error; end

  def initialize opts
    @context     = (opts[:context] or Context)
    @want_labels = read_labels (opts[:labels] or [])
    @context     = @context.new(opts) if @context.class == Class
    @parser      = Parser.new
  end

  def discovered_variables
    @context.discovered_variables
  end

  def parse input
    @parser.parse(input).each do |hash|
      hash.each do |type, value|
        case type
        when :text
          # we don't care, it's not inside template
        when :template
          template value
        else
          raise InvalidType, "#{type} was not recognized by parser"
        end
      end
    end
    @context.str
  end

  private

  def read_labels labels
    pos, neg = [], []
    labels.each do |label|
      label[0] == '!' ? neg.push(label[1..-1]) : pos.push(label)
    end
    [pos, neg]
  end

  def template templ
    templ.each do |hash|
      hash.each do |type, value|
        case type
        when :labels
          return unless valid_labels? read_labels(value.to_str.split)
        when :code
          @context.code value.to_str
        when :text
          @context.text value.to_str
        when :template
          template value
        else
          raise InvalidType, "#{type} was not recognized by parser"
        end
      end
    end
  end

  def valid_labels? got_labels
    # first/[0] is our positive labels (label)
    # last/[1]  is our negative labels (!label)

    # template has label which we explcitly don't want
    return false if (got_labels[0] & @want_labels[1]).size > 0

    # template forbids label which we explicitly want
    return false if (got_labels[1] & @want_labels[0]).size > 0

    # template requires no labels
    return true if got_labels[0].empty?

    # template requires labels, do we want at least one of them?
    return false unless (got_labels[0] & @want_labels[0]).size > 0

    true
  end

end

require_relative 'parser'
require_relative 'context'
