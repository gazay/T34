module T34
  class Rewriter
    module API
      class Proxy

        def initialize(node)
          @node = node
        end

        def respond_to_missing?(method, include_private = false)
          @node.send(:respond_to_missing?, method, include_private)
        end

        def method_missing(method, *args, &block)
          @node.send method, *args, &block
        end

        def type
          :proxy
        end

        def to_ast
          @node
        end

        def replace(source_node, target_node)
          ind = \
            children.
              index (source_node.respond_to?(:to_ast) ? source_node.to_ast : source_node)
          return unless ind
          self.to_ast.instance_eval \
            {
              @children[ind] = \
                (target_node.respond_to?(:to_ast) ? target_node.to_ast : target_node)
            }
        end

        def children
          (@node.respond_to?(:children) && @node.children) ||
            []
        end

        def wrap_with_lambda
          Parser::AST::Node.new(:block,
            [
              Parser::AST::Node.new(:send, [nil, :lambda]),
              Parser::AST::Node.new(:args),
              self.to_ast
            ]
          )
        end

        def wrap_with_block
          Parser::AST::Node.new(:block, [(self.respond_to?(:to_ast) ? self.to_ast : self)])
        end

        def match_type?(node)
          false
        end
      end
    end
  end
end
