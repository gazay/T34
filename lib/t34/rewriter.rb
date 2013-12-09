module T34
  class Rewriter
    def initialize(source)
      @source = source
    end

    def rewrite(&block)
      instance_eval(&block)
    end

    def target
      Unparser.unparse(ast)
    end

    def ast
      @ast ||= Parser::CurrentRuby.parse(@source)
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
  end
end
