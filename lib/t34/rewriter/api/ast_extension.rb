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
              # hack :|
              if node_class == T34::Rewriter::API::BlockNode
                block_node = node_class.new(self)
                send_node = block_node.bound_method
                send_node.block = block_node
                return send_node
              #elsif node_class == T34::Rewriter::API::SendNode && parent.try(:type) == :block
              #  return
              else
                return node_class.new(self)
              end
            end
          end
          self
        end

        def traverse(node = self, parent = nil, &block)
          puts node.inspect
          if parent
            node.parent = parent rescue binding.pry
          end
          if node.respond_to?(:typecast)
            yield node.typecast
          else
            yield node
          end
          if node.respond_to?(:children) && node.children
            node.children
              .select { |child| child.is_a?(AST::Node) }
              .each { |child| traverse(child.typecast, self, &block) }
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
