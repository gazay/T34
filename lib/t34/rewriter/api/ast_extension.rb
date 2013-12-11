module T34
  class Rewriter
    module API
      module ASTExtension

        include Enumerable

        def initialize(type, children=[], properties={})
        # sorry, no more .freeze
          @type, @children = type.to_sym, children.to_a
          assign_properties(properties)
        end

        def typecast
          T34::Rewriter::API::NODES.each do |node_class|
            if node_class.match_type?(self)
              return node_class.new(self)
            end
          end
          self
        end

        def traverse(node = self, &block)
          yield node
          if node.respond_to?(:children)
            node.children
              .select { |child| child.is_a?(AST::Node) }
              .each { |child| traverse(child.typecast, &block) }
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
