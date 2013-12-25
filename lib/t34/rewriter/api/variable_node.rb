module T34
  class Rewriter
    module API

      class VariableNode < Proxy
        def self.match_type?(node)
          node.type == :lvasgn
        end
      end

    end
  end
end
