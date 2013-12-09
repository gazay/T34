CODE = %"
class TestCase1

  def meth(param1, param2 = nil)
    [param1, param2]
  end

end

class Modified1 < TestCase1

  def meth(param1)
    param1
  end

end

tc1 = TestCase1.new
m1 = Modified1.new

puts tc1.meth('abc', 'def') == m1.meth('abc')
"

# rewriting

require 'parser/current'

RULE = {
  method: 'meth',
  params: ['param1']
}

class Rew < Parser::Rewriter
  def on_def(node)
    if node.loc.name.source == RULE[:method]
      args = node.children[1]
      stay_args = []
      args.children.each do |arg|
        if RULE[:params].include? arg.loc.name.source
          stay_args << arg
        end
      end

      final_code = stay_args.map { |arg| arg.loc.expression.source }.join(', ')
      final_code = [args.loc.begin.source, final_code, args.loc.end.source].join
      replace args.loc.expression, final_code
    end
  end
end

buffer = Parser::Source::Buffer.new('(string)')
buffer.source = CODE
parser = Parser::CurrentRuby.new
ast = parser.parse(buffer)
rew = Rew.new
puts rew.rewrite(buffer, ast)

# test
