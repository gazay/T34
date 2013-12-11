module T34
  class Rewriter
    module API
      class ArgsNode < Proxy # ArrayProxy?

        include Enumerable

        def respond_to_missing?(method, include_private = false)
          @node.children.send(:respond_to_missing?, method, include_private)
        end

        def method_missing(method, *args, &block)
          @node.children.send method, *args, &block
        end

        def children
          @node.children
        end

        def children=(a)
          @node.instance_eval { @children = a }
        end

        def pop
          result = children[-1]
          self.children = children[0...-1]
          result
        end

        def method?(*names)
          false
        end

        def each
          children.each { |it| yield ArgNode.new(it) }
        end

        def map!
          result = self.map { |it| yield it }.
            map { |it| it.to_ast }
          self.children = result
        end

        def select!
          result = self.select { |it| yield it }.
            map { |it| it.to_ast }
          self.children = result
        end

        def type
          :args
        end

        def self.match_type?(node)
          node.type == :args
        end

      end
    end
  end
end
