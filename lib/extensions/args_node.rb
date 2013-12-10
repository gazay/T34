module Parser
  module AST
    class ArgsNode < Proxy # ArrayProxy?

      include Enumerable

      def respond_to_missing?(method, include_private = false)
        @node.children.send(:respond_to_missing?, method, include_private)
      end

      def method_missing(method, *args, &block)
        @node.children.send method, *args, &block
      end

      def children
        @node.children
      end

      def children=(a)
        @node.instance_eval { @children = a }
      end

      def pop
        result = children[-1]
        self.children = children[0...-1]
        result
      end

      def method?(*names)
        false
      end

      def each
        children.each { |it| yield Parser::AST::ArgNode.new(it) }
      end

      def map!
        result = self.map { |it| yield it }.
          map { |it| it.to_ast }
        self.children = result
      end

    end
  end
end
