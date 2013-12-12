module T34
  class Rewriter
    module API

      class BlockNode < Proxy

        include T34::Rewriter::API

        def children
          # change if block is emitter of send node
          #@node.children
          @node.children[1..-1].map(&:typecast)
        end

        def children=(new_children)
          @node.instance_eval \
            {
              @children = new_children.
                map { |it| it.respond_to?(:ast) ? it.ast : it }
            }
        end

        def type
          :block
        end

        def args
          ArgsNode.new(@node.children[1])
        end

        def body
          @node.children[2].typecast
        end

        def self.match_type?(node)
          node.type == :block
        end

        # uncomment if block is emitter of send node
        def bound_method
          @bound_method ||= T34::Rewriter::API::SendNode.new @node.children[0]
        end

        def typecast
          self
        end
      end

    end
  end
end
