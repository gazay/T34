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

        def match_type?(node)
          false
        end
      end
    end
  end
end
