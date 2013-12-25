require 'parser/ast/node'

require_relative 'api/ast_extension'
require_relative 'api/proxy'
require_relative 'api/args_node'
require_relative 'api/arg_node'
require_relative 'api/method_node'
require_relative 'api/send_node'
require_relative 'api/block_node'
require_relative 'api/variable_node'

module T34
  class Rewriter
    module API

      NODES = [MethodNode, ArgsNode, ArgNode, SendNode, BlockNode, VariableNode]

      # TODO
      # it should enqueue traverse filter in a queue unless a block given
      # and filter only if block_given? to allow
      # methods(:meth).with(any_argument) # <- implementation of rspec expectation
      def methods(*names)
        methods = []
        ast.traverse do |node|
          if match?(:method, node, names)
            methods << node
            yield node if block_given?
          end
        end
        methods
      end

      def blocks
        blocks = []
        ast.traverse do |node|
          if node.type == :block
            blocks << node
            yield node if block_given?
          end
        end
        blocks
      end

      def variables
        variables = []
        ast.traverse do |node|
          if node.type == :lvasgn
            variables << node
            yield node if block_given?
          end
        end
        variables
      end

      def sends(*names)
        sends = []
        ast.traverse do |node|
          if match?(:send, node, names, :method_name)
            sends << node
            yield node if block_given?
          end
        end
        sends
      end

      private

      def match?(type, node, names = [], name_method = :name)
        result = node.type == type
        if node.respond_to?(name_method)
          result = result &&
            (names.empty? || names.include?(node.send(name_method)))
        end

        result
      end

    end
  end
end
