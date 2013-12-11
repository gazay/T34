module T34
  class Rewriter
    module API

      class SendNode < Proxy

        attr_reader :block

        include T34::Rewriter::API

        def initialize(node)
          if node.type == :block
            @node = node.children[0]
            @block = node
          else
            @node = node
            @block = nil
          end
        end

        def children
          @node.children
        end

        def with_block?
          !!@block
        end

        def method_name
          children && children[1]
        end

        def arg_values
          children && children[2..-1]
        end

        def method_missing(method, *args, &block)
          if method.to_s =~ /=/
            case method
            when :method_name=
              @node.instance_eval \
                { @children = [children[0], args.first] + children[2..-1] }
            when :arg_values=
              @node.instance_eval \
              {
                @children = children[0..1] + args.map do |it|
                  it.respond_to?(:to_ast) ? it.to_ast : it
                end
              }
            end
          else
            @node.loc.send(method).source
          end
        end

        def ast
          @node
        end

        def type
          :send
        end

        def to_ast
          if with_block?
            @block.instance_eval { @children = [@node] + @block.children[1..-1] }
          else
            @node
          end
        end

        def self.match_type?(node)
          node.type == :send ||
            (node.type == :block && node.children[0].type == :send)
        end
      end

    end
  end
end
