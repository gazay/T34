require 'spec_helper'

describe 't34' do
  let(:target) {
"class X
  def test_method(arg1)
  end
end # X"
  }

  let(:target2) {
"class X
  def test_method(xxx, arg2)
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
    expect(rewriter.methods(:test_method)).to be_kind_of Array
  end

  it 'finds method nodes' do
    expect(rewriter.methods(:test_method).map(&:class).compact).to eq [T34::Rewriter::API::MethodNode]
  end

  it 'manipulates methods' do
    res = rewriter.methods(:test_method) do |method_node|
      method_node.args = method_node.args[0...-1]
    end
    expect(res[0].args.size).to eq 1
  end

  it 'manipulates arguments by name' do
    res = rewriter.methods(:test_method) do |method_node|
      method_node.args = method_node.args.select { |it| it.name != 'arg2' }
    end
    expect(res[0].args.size).to eq 1
    expect(rewriter.target).to eq target
  end

  it 'manipulates arguments by name with select!' do
    res = rewriter.methods(:test_method) do |method_node|
      method_node.args.select! { |it| it.name != 'arg2' }
    end
    expect(res[0].args.size).to eq 1
    expect(rewriter.target).to eq target
  end

  it 'renames arguments' do
    res = rewriter.methods(:test_method) do |method_node|
      method_node.args = method_node.args.map do |it|
        if it.name == 'arg1'
          it.name = 'xxx'
        end
        it
      end
    end
    expect(rewriter.target).to eq target2
  end

  it 'generates code back' do
    rewriter.rewrite do
      methods(:test_method) do |method_node|
        method_node.args = method_node.args[0...-1]
      end
    end

    expect(rewriter.target).to eq target
  end
end
