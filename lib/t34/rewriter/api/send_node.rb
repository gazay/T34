module T34
  class Rewriter
    module API

      class SendNode < Proxy

<<<<<<< Updated upstream
        attr_accessor :type, :children

        def initialize(type, children = [], properties={})
          super
=======
        attr_accessor :block

        def children
          children = @node.children
          children << block if block
          children
>>>>>>> Stashed changes
        end

        def method_name
          children[1]
        end

        def method_missing(method, *args, &block)
          if method.to_s =~ /=/
            case method
            when :method_name=
              @node.instance_eval { @children = [children[0], args.first] + children[2..-1] }
            end
          else
            @node.loc.send(method).source
          end
        end


        def args=(new_args)
          args.children = \
            new_args.map { |it| it.respond_to?(:to_ast) ? it.to_ast : it }
        end

        def type
          :send
        end

        def self.match_type?(node)
          node.type == :send
        end
      end

    end
  end
end
