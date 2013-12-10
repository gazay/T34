module Parser
  module AST

    class MethodNode < Proxy
      def args
        _, args, _ = children # name, args, block
        Parser::AST::ArgsNode.new(args)
      end

      def args=(new_args)
        args.children = \
          new_args.map { |it| it.respond_to?(:to_ast) ? it.to_ast : it }
      end
    end

  end
end
