module Parser
  module AST
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
    end
  end
end
