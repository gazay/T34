module T34
  class Rewriter
    module API
      module ASTExtension

        include Enumerable
        attr_accessor :parent

        def initialize(type, children=[], properties={})
          # sorry, no more .freeze
          @type, @children = type.to_sym, children.to_a
          assign_properties(properties)
        end

        def typecast
          T34::Rewriter::API::NODES.each do |node_class|
            if node_class.match_type?(self)
              # change if block is emitter of send
              if node_class == T34::Rewriter::API::BlockNode
                block_node = node_class.new(self)
                send_node = block_node.bound_method
                send_node.block = block_node
                return send_node
              end
              return node_class.new(self)
            end
          end
          self
        end

        def traverse(node = self, parent = nil, &block)
          if parent
            node.parent = parent
          end
          casted = node.respond_to?(:typecast) ? node.typecast : node
          yield casted
          if casted.respond_to?(:children) && casted.children
            # change if block is emitter of send
            # .select { |child| child.is_a?(AST::Node) }
            casted.children
              .select { |child| child.is_a?(AST::Node) || child.is_a?(T34::Rewriter::API::BlockNode) }
              .each { |child| traverse(child, self, &block) }
          end
        end

        def each
          children.each { |it| yield it }
        end
      end
    end
  end
end

Parser::AST::Node.send(:include, T34::Rewriter::API::ASTExtension)
