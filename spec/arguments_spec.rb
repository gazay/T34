require 'spec_helper'

describe 't34' do
  let(:target) {
"class X
  def test_method(arg1)
  end
end # X"
  }

  let(:source) {
"class X
  def test_method(arg1, arg2)
  end
end"
  }

  let(:rewriter) {
    T34::Rewriter.new source
  }

  it 'finds methods' do
    expect(rewriter.methods(:test_method).map(&:class).compact).to be_kind_of Array
  end

  it 'finds method nodes' do
    expect(rewriter.methods(:test_method).map(&:class).compact).to eq [Parser::AST::MethodNode]
  end

  it 'manipulates methods' do
    res = rewriter.methods(:test_method) do |method_node|
      method_node.args.pop
    end
    expect(res[0].args.size).to eq 1
  end

  it 'generates code back' do
    rewriter.rewrite do
      methods(:test_method) do |method_node|
        method_node.args.pop
      end
    end
    expect(rewriter.target).to eq target
  end
end
