module T34
  class Rewriter
    class MethodNode

      def initialize(node)
        @node = node
      end

      def args
        args = @node.children.find do |child|
          child.respond_to?(:type) && child.type == :args
        end
        args.children if args
      end

      def arg_names
        args.map { |arg| arg.children[0] }
      end

      def method_missing(method_name, *args, &block)
        @node.send(method_name, *args, &block)
      end

      def respond_to_missing?(method_name, include_private = false)
        @node.respond_to?(method_name, include_private) || super
      end

    end
  end
end
