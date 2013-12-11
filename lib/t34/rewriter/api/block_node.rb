module T34
  class Rewriter
    module API

      class BlockNode < Proxy

        def type
          :block
        end

        def self.match_type?(node)
          node.type == :block && node.children[0].type == :send
        end

        def bound_method
          T34::Rewriter::API::SendNode.new @node.children[0]
        end

        def children
          @node.children[1..-1]
        end
      end

    end
  end
end
