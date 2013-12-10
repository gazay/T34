module Parser
  module AST

    class MethodNode < Proxy
      def args
        _, args, _ = children # name, args, block
        Parser::AST::ArgsNode.new(args)
      end
    end

  end
end
