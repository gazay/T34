require 'spec_helper'

describe 't34' do

  let(:source) {
"class X
  def test_method(arg1, arg2)
  end
end"
  }

  let(:target) {
"class X
{\"  def test_method(arg1)\" >> \"  def test_method(arg1, arg2)\"}
  end
{\"end # X\" >> \"end\"}"
  }

  let(:rewriter) {
    T34::Rewriter.new source
  }

  it 'produces right diff' do
    rewriter.rewrite do
      methods(:test_method) do |method_node|
        method_node.args = method_node.args[0...-1]
      end
    end

    expect(rewriter.diff.to_s).to eq target
  end
end
