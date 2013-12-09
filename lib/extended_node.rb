require 'parser/ast/node'

module Parser
  module AST
    class Proxy
      def initialize(node)
        @node = node
      end

      def respond_to_missing?(method, include_private = false)
        @node.send(:respond_to_missing?, method, include_private)
      end

      def method_missing(method, *args, &block)
        @node.send method, *args, &block
      end
    end

    class ArgsNode < Proxy # ArrayProxy?
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
        self.children = children[0...-1] # ZOMG
      end

      def method?(*names)
        false
      end
    end

    class MethodNode < Proxy
      def args
        _, args, _ = children # name, args, block
        Parser::AST::ArgsNode.new(args)
      end
    end
  end
end

module ExtendedNode
  # sorry, no more .freeze
  def initialize(type, children=[], properties={})
    @type, @children = type.to_sym, children.to_a
    assign_properties(properties)
  end

  def class?
    type == :class
    #type == :const && children.size == 3 &&
    #  children[1].is_a?(Symbol) &&              # class name
    #  (children[0].nil? || children[0].class?)  # inheritance
  end

  def args?
    type == :args
  end

  def method?(*names)
    type == :def && (names.empty? || names.include?(children[0]))
  end

  def typecast
    return Parser::AST::MethodNode.new(self) if method?
    return Parser::AST::ArgsNode.new(self) if args?
    self
  end

  def traverse(node = self, &block)
    yield node
    node.children
      .select { |child| child.is_a?(AST::Node) }
      .each { |child| traverse(child.typecast, &block) }
  end
end

Parser::AST::Node.send(:include, ExtendedNode)
