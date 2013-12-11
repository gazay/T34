require_relative 'rewriter/api'

module T34
  class Rewriter

    include T34::Rewriter::API

    DIFF_KINDS = %w(line word char)

    attr_reader :source, :source_ast

    def initialize(source)
      @source = @target = source
      @source_ast = @target_ast = Parser::CurrentRuby.parse(@source)
    end

    def rewrite(&block)
      instance_eval(&block)
    end
    alias_method :rewrite_plain, :rewrite

    def ast
      @target_ast = Parser::CurrentRuby.parse(@target)
    end
    alias_method :target_ast, :ast

    def target
      @target = Unparser.unparse(@target_ast)
    end

    def diff(kind = 'line')
      unless DIFF_KINDS.include? kind
        raise ArgummentError.new('Wrong type of diff. Can be line, word and char')
      end

      Differ.send("diff_by_#{kind}", source, target)
    end
  end
end
