module Parser
  module AST
    class ArgNode < Proxy

      def respond_to_missing?(method, include_private = false)
        @node.loc.send(:respond_to_missing?, method, include_private)
      end

      def method_missing(method, *args, &block)
        require 'byebug'
        byebug
        if method.to_s =~ /=/
          case method
          when :name=
            @node.instance_eval { @children = [args.first] + children[1..-1] }
          end
        else
          @node.loc.send(method).source
        end
      end

      def to_ast
        @node
      end

      def method?(*names)
        false
      end

    end
  end
end
