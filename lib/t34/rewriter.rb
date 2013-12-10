module T34
  class Rewriter

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

    # TODO
    # it should enqueue traverse filter in a queue unless a block given
    # and filter only if block_given? to allow
    # methods(:meth).with(any_argument) # <- implementation of rspec expectation
    def methods(*names)
      methods = []
      ast.traverse do |node|
        if node.method?(*names)
          methods << node
          yield node if block_given?
        end
      end
      methods
    end


    def diff(kind = 'line')
      unless DIFF_KINDS.include? kind
        raise ArgummentError.new('Wrong type of diff. Can be line, word and char')
      end

      Differ.send("diff_by_#{kind}", source, target)
    end
  end
end
