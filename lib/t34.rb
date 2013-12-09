require 'parser/current'
require 'unparser'
require File.expand_path("../extended_node.rb", __FILE__)

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
