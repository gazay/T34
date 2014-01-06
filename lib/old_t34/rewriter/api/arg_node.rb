module T34
  class Rewriter
    module API
      class ArgNode < Proxy

        def respond_to_missing?(method, include_private = false)
          @node.loc.send(:respond_to_missing?, method, include_private)
        end

        def method_missing(method, *args, &block)
          if method.to_s =~ /=/
            case method
            when :name=
              @node.instance_eval { @children = [args.first] + children[1..-1] }
            end
          else
            @node.loc.send(method).source
          end
        end

        def type
          :arg
        end

        def self.match_type?(node)
          node.type == :arg
        end

      end
    end
  end
end
