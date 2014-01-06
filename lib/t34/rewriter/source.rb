module T34
  class Rewriter
    class Source

      def initialize(code)
        @code = Parser::CurrentRuby.parse(code)
      end

      def methods
        @methods ||= get_methods(@code)
      end

      def method_names
        methods.keys
      end

      private

      def get_methods(node)
        methods = {}
        if node.respond_to?(:type) && node.type == :def
          methods[node.children.first] = T34::Rewriter::MethodNode.new(node)
        elsif node.respond_to?(:children)
          node.children.each do |n|
            methods = methods.merge(get_methods(n))
          end
        end
        methods
      end
    end
  end
end
