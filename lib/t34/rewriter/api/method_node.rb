module T34
  class Rewriter
    module API

      class MethodNode < Proxy
        def args
          _, args, _ = children # name, args, block
          ArgsNode.new(args)
        end

        def args=(new_args)
          args.children = \
            new_args.map { |it| it.respond_to?(:to_ast) ? it.to_ast : it }
        end

        def name
          children[0]
        end

        def type
          :method
        end

        def self.match_type?(node)
          node.type == :def
        end
      end

    end
  end
end
