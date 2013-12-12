module T34
  class Rewriter
    module API

      class SendNode < Proxy

        # if it's a bound_method of block (@block is present)
        # ALL operation ON AST should be passed to that block
        # think about this object just as a proxy shim to improve hierarchy before
        # the block containing actual parsed method name, caller, etc in block.children[0]
        # and backreferenced as bound_method
        attr_accessor :block

        include T34::Rewriter::API

        # comment out if change to block node as send emitter
        #def initialize(node)
        #  if node.type == :block
        #    @node = node.children[0]
        #    @block = node
        #  else
        #    @node = node
        #    @block = nil
        #  end
        #end

        def args
          _, _, args, _ = children # caller, name, args, block
          ArgsNode.new(args)
        end

        def args=(new_args)
          blocks = new_args.delete_if { |a| a.is_a? BlockNode }
          raise 'cannot accept more than one block' if blocks.size > 1
          self.block = blocks[0]
          @node.children = new_args
          args
        end


        def children
          # uncomment if change to block node as send emitter
          #@node.children
          if block
            @node.children + [block]
          else
            @node.children
          end
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
                  it.respond_to?(:ast) ? it.ast : it
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

        def ast
          if with_block?
            #@block.instance_eval { @children = [@node] + @block.children[1..-1] }
            @block.ast
          else
            @node
          end
        end

        def self.match_type?(node)
          node.type == :send
          #node.type == :send ||
          #  (node.type == :block && node.children[0].type == :send)
        end
      end

    end
  end
end
