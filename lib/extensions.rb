require 'parser/ast/node'

require_relative 'extensions/proxy'
require_relative 'extensions/args_node'
require_relative 'extensions/method_node'

module Extensions

  include Enumerable

  # sorry, no more .freeze
  def initialize(type, children=[], properties={})
    @type, @children = type.to_sym, children.to_a
    assign_properties(properties)
  end

  def class?
    type == :class
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

  def each
    children.each { |it| yield it }
  end
end

Parser::AST::Node.send(:include, Extensions)
