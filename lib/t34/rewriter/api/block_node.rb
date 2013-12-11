module T34
  class Rewriter
    module API

      class BlockNode < Proxy

        include T34::Rewriter::API

        def children
          @node.children
        end

        def children=(new_children)
          @node.instance_eval \
            {
              @children = new_children.
                map { |it| it.respond_to?(:to_ast) ? it.to_ast : it }
            }
        end

        def ast
          @node
        end

        def type
          :block
        end

        def to_ast
          @node
        end

        def self.match_type?(node)
          node.type == :block
        end
      end

    end
  end
end
