require 'parser/ast/node'

require_relative 'api/ast_extension'
require_relative 'api/proxy'
require_relative 'api/args_node'
require_relative 'api/arg_node'
require_relative 'api/method_node'
require_relative 'api/send_node'
require_relative 'api/block_node'

module T34
  class Rewriter
    module API

      NODES = [MethodNode, ArgsNode, ArgNode, SendNode, BlockNode]

      # TODO
      # it should enqueue traverse filter in a queue unless a block given
      # and filter only if block_given? to allow
      # methods(:meth).with(any_argument) # <- implementation of rspec expectation
      def methods(*names)
        methods = []
        ast.traverse do |node|
          if method_match?(node, names)
            methods << node
            yield node if block_given?
          end
        end
        methods
      end

      def blocks
        blocks = []
        ast.traverse do |node|
          if match?(:block, node)
            blocks << node
            yield node if block_given?
          end
        end
        blocks
      end

      def sends(*names)

      end

      private

      def method_match?(node, names = [])
        node.type == :method &&
          (names.empty? || names.include?(node.name))
      end

    end
  end
end
